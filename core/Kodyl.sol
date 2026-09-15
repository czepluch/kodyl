// Kodyl, implemented natively in Core Solidity.
//
// The concept (spec.md): attendees stake a deposit to register for an event,
// checked-in attendees reclaim it plus a pro-rata share of no-show
// forfeitures, leftover dust goes to a maintainer.
//
// Where Solidity's natural unit of isolation is a contract instance (hence
// the classic factory-deploys-one-contract-per-event architecture), Core
// Solidity's natural unit is a value in a typed map. So this is a singleton:
// an event is a payload-carrying ADT stored behind an id, "deployment" is a
// state write, and the missing-event case is a constructor the type system
// forces every consumer to handle. One consequence is shared custody: all
// deposits live in one contract balance, tracked by a per-event pot plus a
// global ledger, with the invariant balance >= total asserted after every
// ETH movement. The direction is >=, not ==: forced ETH (selfdestruct /
// block-reward payments) can push the balance above the ledger and cannot
// be rejected, so == would let 1 wei permanently brick every flow. The
// surplus is simply unowned and stuck. The accounting itself lives in
// lib.ledger, an opaque module whose only exports are credit / payOut plus
// the two reads - raw pot mutation and raw ETH transfer are unreachable
// from here by construction.
import * from std;
import {callvalue as callvalue_, shr, calldatasize, calldataload} from std.opcodes;
import {frombool} from std;
import * from std.dispatch;
import * from std.Generic;
import * from std.StorageGeneric;
import * from std.eip712;
import * from lib.kodyl;
import * from lib.ledger;

// --- ADTs ---
// Sums carry the cases and stay pattern-matched (exhaustiveness is the
// point); wide products carry names. Positional destructuring of seven
// fields - five of them uint256 - was a silent-swap hazard the names remove.

// Lifecycle state, derived from timestamps (never stored).
enum State { Registration, Active, Dispute, Settled, Cancelled }

// Stored per (event, attendee). None is declared first so an unset mapping
// key (the all-zero slot pattern) reads back as None.
enum AttendeeStatus { None, Registered, Cancelled, CheckedIn, Claimed, Rebated }

// The immutable parameters of an event, set once at creation.
struct EventRecord {
    organizer: address;
    deposit: uint256;
    cancellationDeadline: uint256;
    eventStart: uint256;
    eventEnd: uint256;
    disputePeriod: uint256;
    maxAttendees: uint256; // 0 = unlimited
}

// An event: either absent, or its record. NoEvent is first so an unset id
// reads back as NoEvent, and exhaustive matching forces every function to
// decide what a missing event means. Storage layout: tag word + the record's
// fields, identical to the previous positional payload.
enum EventRec { NoEvent, Ev(EventRecord) }

// Per-event tallies behind the event id. A plain product lays out as
// consecutive slots with NO tag word, so an unset id reads back as
// Counters(0, 0, 0) from the all-zero slots - the same zero-slot design
// rule as NoEvent/None. Struct member writes through a mapping value are not
// implemented at this pin (SC0231), so updates read the record and write a
// whole reconstructed value - which is also the discipline that keeps the
// tallies moving together. The per-event POT is not here: money lives in
// lib.ledger, behind its opaque credit/payOut boundary.
struct Counters {
    registered: uint256;
    checkedIn: uint256;
    claimed: uint256;
}

// --- ordinals (ADTs stay Solidity-compatible at the ABI boundary) ---

function stateOrd(s: State) returns (uint256) {
    match (s) {
    case State.Registration { return 0; }
    case State.Active       { return 1; }
    case State.Dispute      { return 2; }
    case State.Settled      { return 3; }
    case State.Cancelled    { return 4; }
    }
}

function statusOrd(s: AttendeeStatus) returns (uint256) {
    match (s) {
    case AttendeeStatus.None       { return 0; }
    case AttendeeStatus.Registered { return 1; }
    case AttendeeStatus.Cancelled  { return 2; }
    case AttendeeStatus.CheckedIn  { return 3; }
    case AttendeeStatus.Claimed    { return 4; }
    case AttendeeStatus.Rebated    { return 5; }
    }
}

// Pure state derivation: cancellation dominates, otherwise the clock decides.
function deriveState(isCancelled: bool, rec: EventRecord) returns (State) {
    if (isCancelled) { return State.Cancelled; }
    let t = timeNow();
    if (t < rec.eventStart) { return State.Registration; }
    if (t <= rec.eventEnd) { return State.Active; }
    if (t <= addCk(rec.eventEnd, rec.disputePeriod)) { return State.Dispute; }
    return State.Settled;
}

function revertNotFound() {
    fail("EventNotFound()");
}

// Check-ins are valid only in Active or Dispute. Gating on the derived state
// (rather than a raw time window) also rejects check-ins on a cancelled event,
// where the state is Cancelled - otherwise an attendee could be flipped to
// CheckedIn and then never recover their deposit.
function requireCheckInOpen(isCancelled: bool, rec: EventRecord) {
    let s = stateOrd(deriveState(isCancelled, rec));
    if (s != 1 && s != 2) {
        fail("CheckInWindowClosed()");
    }
}

// Exhaustive registration gate: the type system forces a decision for every
// status. None and Cancelled may (re-)register; everything else names its
// own failure.
function registerGuard(st: AttendeeStatus) {
    match (st) {
    case AttendeeStatus.None      { return; }
    case AttendeeStatus.Cancelled { return; }
    case AttendeeStatus.Registered {
        fail("AlreadyRegistered()");
    }
    case AttendeeStatus.CheckedIn {
        revertWith2("InvalidAttendeeStatus(uint8,uint8)", 3, 0);
    }
    case AttendeeStatus.Claimed {
        revertWith2("InvalidAttendeeStatus(uint8,uint8)", 4, 0);
    }
    case AttendeeStatus.Rebated {
        // Unreachable in practice (Rebated only exists at Settled, where
        // registration is closed), but the exhaustive match names it anyway.
        revertWith2("InvalidAttendeeStatus(uint8,uint8)", 5, 0);
    }
    }
}

function requireStatus(st: AttendeeStatus, expected: word) {
    let cur = Typedef.rep(statusOrd(st));
    if (cur != expected) {
        revertWith2("InvalidAttendeeStatus(uint8,uint8)", cur, expected);
    }
}

function onlyOrganizerOf(org: address) {
    requireK(caller() == org, "NotOrganizer()");
}

// --- EIP-712 hashing (proof-based check-in) ---
// The two message structs are hashed by hand - std has no hashStruct helper:
// keccak256(typeHash ++ one 32-byte word per member), the typeHash folded at
// compile time. The type strings are the wire contract with off-chain
// signers: test/Kodyl.t.sol pins them (TICKET_TYPEHASH / PRESENCE_TYPEHASH)
// with an independent keccak, and the frontend signer must match the
// same strings byte-for-byte.

// The attendee address is deliberately NOT in the Ticket payload: ecrecover
// yields the signer, and verifyProof requires it to equal the attendee
// argument - the signature itself is the address binding.
function hashTicket(eid: uint256) returns (bytes32) {
    let typeHash = bytes32(keccakLit("Ticket(uint256 eventId)"));
    return keccak256_(concat(typeHash, bytes32(Typedef.rep(eid))));
}

function hashPresence(eid: uint256, attendee: address) returns (bytes32) {
    let typeHash = bytes32(
        keccakLit("Presence(uint256 eventId,address attendee)"));
    return keccak256_(concat(
        typeHash,
        concat(bytes32(Typedef.rep(eid)), bytes32(Typedef.rep(attendee)))
    ));
}

// Domain separator: name "Kodyl", version "1", the runtime chain id, this
// contract. Computed per call (caching in storage is a later optimization);
// binds every proof to one deployment on one chain.
function domainSep() returns (bytes32) {
    return eip712DomainSeparator(
        bytes32(keccakLit("Kodyl")), bytes32(keccakLit("1")), chainId(), self());
}

contract Kodyl {
    maintainer: address;
    eventCount: uint256;
    // No pot fields here: the per-event pot and the global deposit ledger
    // (spec.md invariant 1) are lib.ledger's namespaced storage, reachable
    // only through its credit / payOut / potOf / ledgerTotal exports.

    // Per-event state, keyed by eventId (1..eventCount; id 0 is never used,
    // so the NoEvent zero pattern is unreachable for real ids).
    eventsRec: mapping(uint256 => EventRec);
    // Sequential ids make an array the natural container; ids are 1-based so
    // the URI for event eid lives at index eid - 1.
    metadataUris: array<string>;
    cancelledM: mapping(uint256 => bool);
    statusM: mapping(uint256 => mapping(address => AttendeeStatus));
    countersM: mapping(uint256 => Counters);
    // Door operators authorized to countersign Presence proofs, per event.
    // The zero slot reads false (not operator) - the zero-pattern rule.
    operatorsM: mapping(uint256 => mapping(address => bool));

    constructor(maintainer_: address) {
        // The ONE surviving packed-word reason ("Zero address"): string
        // literals do not materialize in deploy code (allocators live in the
        // runtime object only; solcore doc/comptime-string.md gap table), so
        // the constructor cannot route through revertStr.
        if (Typedef.rep(maintainer_) == 0) {
            revertStr1(shr(224, keccakLit("InvalidEventParameters(string)")), 12,
                       0x5a65726f20616464726573730000000000000000000000000000000000000000);
        }
        maintainer = maintainer_;
    }

    // --- event creation: a state write, not a deployment ---

    function createEvent(
        depositAmount: uint256,
        cancellationDeadline: uint256,
        eventStart: uint256,
        eventEnd: uint256,
        disputePeriod: uint256,
        maxAttendees: uint256,
        metadataURI_: memory<string>
    ) public returns (uint256) {
        validateEventParams(depositAmount, cancellationDeadline, eventStart, eventEnd, disputePeriod);

        let eid = eventCount + 1;
        eventCount = eid;
        eventsRec[eid] = EventRec.Ev(EventRecord(caller(), depositAmount, cancellationDeadline,
                                                 eventStart, eventEnd, disputePeriod, maxAttendees));
        metadataUris.push(metadataURI_);

        emitLog3W3(keccakLit("EventCreated(uint256,address,uint256,uint256,uint256)"),
                   Typedef.rep(eid), Typedef.rep(caller()),
                   Typedef.rep(depositAmount), Typedef.rep(eventStart), Typedef.rep(eventEnd));

        return eid;
    }

    // --- read surface ---

    function maintainer() public returns (address) { return maintainer; }
    function eventCount() public returns (uint256) { return eventCount; }
    function totalHeld() public returns (uint256) { return ledgerTotal(); }

    // All seven parameters of an event in one call; reverts for unknown ids.
    function getEvent(eid: uint256)
        public returns ((address, uint256, uint256, uint256, uint256, uint256, uint256)) {
        match (eventsRec[eid]) {
        case EventRec.NoEvent {
            revertNotFound();
            return (address(0), 0, 0, 0, 0, 0, 0);
        }
        case EventRec.Ev(rec) {
            return (rec.organizer, rec.deposit, rec.cancellationDeadline, rec.eventStart,
                    rec.eventEnd, rec.disputePeriod, rec.maxAttendees);
        }
        }
    }

    function organizer(eid: uint256) public returns (address) {
        match (eventsRec[eid]) {
        case EventRec.NoEvent { revertNotFound(); return address(0); }
        case EventRec.Ev(rec) { return rec.organizer; }
        }
    }

    function getState(eid: uint256) public returns (uint256) {
        match (eventsRec[eid]) {
        case EventRec.NoEvent { revertNotFound(); return 0; }
        case EventRec.Ev(rec) {
            return stateOrd(deriveState(cancelledM[eid], rec));
        }
        }
    }

    function attendees(eid: uint256, a: address) public returns (uint256) {
        return statusOrd(statusM[eid][a]);
    }

    function metadataURI(eid: uint256) public returns (memory<string>) {
        match (eventsRec[eid]) {
        // Index literals stay cast: array indexing is generic over the index
        // type, so a bare 0 leaves it ambiguous.
        case EventRec.NoEvent { revertNotFound(); return metadataUris[uint256(0)]; }
        case EventRec.Ev(rec) {
            return metadataUris[eid - 1];
        }
        }
    }

    function cancelled(eid: uint256) public returns (bool) { return cancelledM[eid]; }

    // Counter getters keep their per-field signatures; each projects one
    // field out of the record (unknown id: the zero record, so 0).
    function registeredCount(eid: uint256) public returns (uint256) {
        let c: Counters = countersM[eid];
        return c.registered;
    }
    function checkedInCount(eid: uint256) public returns (uint256) {
        let c: Counters = countersM[eid];
        return c.checkedIn;
    }
    function claimedCount(eid: uint256) public returns (uint256) {
        let c: Counters = countersM[eid];
        return c.claimed;
    }
    function held(eid: uint256) public returns (uint256) {
        return potOf(eid);
    }

    function rewardPerAttendee(eid: uint256) public returns (uint256) {
        match (eventsRec[eid]) {
        case EventRec.NoEvent { revertNotFound(); return 0; }
        case EventRec.Ev(rec) {
            let c: Counters = countersM[eid];
            return calcReward(c.registered, c.checkedIn, rec.deposit);
        }
        }
    }

    // The per-no-show rebate under the reward cap (0 when the cap is not
    // binding). Record-backed like rewardPerAttendee: unknown ids revert.
    function noShowRebate(eid: uint256) public returns (uint256) {
        match (eventsRec[eid]) {
        case EventRec.NoEvent { revertNotFound(); return 0; }
        case EventRec.Ev(rec) {
            let c: Counters = countersM[eid];
            return calcRebate(c.registered, c.checkedIn, rec.deposit);
        }
        }
    }

    // Pro-rata share of forfeited no-show deposits per checked-in attendee,
    // capped at rewardCapMultiple() * deposit: attendance is a bounded bonus,
    // not a lottery, so a checked-in sybil can extract at most the cap however
    // many honest registrations it farms. Takes the tallies as arguments:
    // callers already hold a Counters value and must not re-read the mapping.
    function calcReward(reg: uint256, chk: uint256, dep: uint256) returns (uint256) {
        if (chk == 0) { return 0; }
        let noShow = subCk(reg, chk);
        let uncapped = mulCk(noShow, dep) / chk;
        let capped = mulCk(rewardCapMultiple(), dep);
        if (uncapped > capped) { return capped; }
        return uncapped;
    }

    // Per-no-show rebate: the forfeitures the cap keeps away from claimants,
    // split pro-rata across the no-shows. Nonzero only when the forfeiture
    // pool exceeds the claimants' capped total - the regime a fake event or
    // a mass no-show produces. Zero check-ins is abandonment (claimRefund
    // pays in full), never a rebate.
    function calcRebate(reg: uint256, chk: uint256, dep: uint256) returns (uint256) {
        if (chk == 0) { return 0; }
        let noShow = subCk(reg, chk);
        if (noShow == 0) { return 0; }
        let forfeited = mulCk(noShow, dep);
        let capTotal = mulCk(chk, mulCk(rewardCapMultiple(), dep));
        if (forfeited <= capTotal) { return 0; }
        return subCk(forfeited, capTotal) / noShow;
    }

    // Public constant getters: forward to the lib.kodyl nullary functions,
    // the single source every internal guard reads too.
    function MAX_BATCH_SIZE() public returns (uint256) { return maxBatchSize(); }
    function DUST_CLAIM_TIMEOUT() public returns (uint256) { return dustClaimTimeout(); }
    function MIN_CANCELLATION_BUFFER() public returns (uint256) { return minCancellationBuffer(); }
    function REWARD_CAP_MULTIPLE() public returns (uint256) { return rewardCapMultiple(); }

    // --- attendee flow ---

    function register(eid: uint256) public payable returns (()) {
        match (eventsRec[eid]) {
        case EventRec.NoEvent { revertNotFound(); }
        case EventRec.Ev(rec) {
            requireK(stateOrd(deriveState(cancelledM[eid], rec)) == 0,
                     "RegistrationClosed()");
            registerGuard(statusM[eid][caller()]);
            if (caller_value() != rec.deposit) {
                revertWith2("IncorrectDeposit(uint256,uint256)",
                            Typedef.rep(rec.deposit), Typedef.rep(caller_value()));
            }
            let c: Counters = countersM[eid];
            if (rec.maxAttendees > 0 && c.registered >= rec.maxAttendees) {
                fail("EventFull()");
            }
            statusM[eid][caller()] = AttendeeStatus.Registered;
            countersM[eid] = Counters(c.registered + 1, c.checkedIn, c.claimed);
            // credit attributes the deposit to pot + total and asserts the
            // balance invariant - the ledger's boundary, not this file's.
            credit(eid, rec.deposit);

            emitLog3(keccakLit("Registered(uint256,address)"),
                     Typedef.rep(eid), Typedef.rep(caller()));
        }
        }
    }

    function cancel(eid: uint256) public returns (()) {
        match (eventsRec[eid]) {
        case EventRec.NoEvent { revertNotFound(); }
        case EventRec.Ev(rec) {
            requireK(timeNow() <= rec.cancellationDeadline, "CancellationDeadlinePassed()");
            requireStatus(statusM[eid][caller()], 1);

            statusM[eid][caller()] = AttendeeStatus.Cancelled;
            let c: Counters = countersM[eid];
            countersM[eid] = Counters(c.registered - 1, c.checkedIn, c.claimed);
            payOut(eid, caller(), rec.deposit);

            emitLog3(keccakLit("RegistrationCancelled(uint256,address)"),
                     Typedef.rep(eid), Typedef.rep(caller()));
        }
        }
    }

    // Refund path without organizer cooperation. Open in two regimes with the
    // same shape: the organizer cancelled (always, regardless of the
    // cancellation deadline), or a non-cancelled event settled with ZERO
    // check-ins - abandonment, indistinguishable on-chain from a fake event
    // or a no-show door, so the fail-safe outcome is everyone's deposit back.
    // Both pots are exactly the sum of attributed deposits: refunds never
    // expire and there is no dust to sweep (claimDust refuses chk == 0).
    function claimRefund(eid: uint256) public returns (()) {
        match (eventsRec[eid]) {
        case EventRec.NoEvent { revertNotFound(); }
        case EventRec.Ev(rec) {
            let c: Counters = countersM[eid];
            let wasCancelled = cancelledM[eid];
            let abandoned =
                stateOrd(deriveState(wasCancelled, rec)) == 3 && c.checkedIn == 0;
            requireK(wasCancelled || abandoned, "EventNotCancelled()");
            requireStatus(statusM[eid][caller()], 1);

            statusM[eid][caller()] = AttendeeStatus.Cancelled;
            countersM[eid] = Counters(c.registered - 1, c.checkedIn, c.claimed);
            payOut(eid, caller(), rec.deposit);

            emitLog3W1(keccakLit("RefundClaimed(uint256,address,uint256)"),
                       Typedef.rep(eid), Typedef.rep(caller()), Typedef.rep(rec.deposit));
        }
        }
    }

    function claim(eid: uint256) public returns (()) {
        match (eventsRec[eid]) {
        case EventRec.NoEvent { revertNotFound(); }
        case EventRec.Ev(rec) {
            requireK(stateOrd(deriveState(cancelledM[eid], rec)) == 3,
                     "NotSettled()");
            requireStatus(statusM[eid][caller()], 3);

            statusM[eid][caller()] = AttendeeStatus.Claimed;
            let c: Counters = countersM[eid];
            let payout = addCk(rec.deposit, calcReward(c.registered, c.checkedIn, rec.deposit));
            // During normal settlement the pot always covers every remaining
            // payout, so payout > pot can only mean the pot was already
            // swept to the maintainer after DUST_CLAIM_TIMEOUT. Report that
            // plainly instead of letting the ledger's checked debit underflow
            // into an opaque Panic(0x11).
            requireK(payout <= potOf(eid), "PayoutSwept()");
            countersM[eid] = Counters(c.registered, c.checkedIn, c.claimed + 1);
            payOut(eid, caller(), payout);

            emitLog3W1(keccakLit("Claimed(uint256,address,uint256)"),
                       Typedef.rep(eid), Typedef.rep(caller()), Typedef.rep(payout));
        }
        }
    }

    // A no-show's pull-claim for the capped-off excess (see calcRebate).
    // Registered-but-not-checked-in only, at Settled, and only when the cap
    // is binding - the terminal Rebated status prevents double claims and
    // deliberately does NOT touch registeredCount, so reward and rebate math
    // stay frozen for every later claimant. PayoutSwept mirrors claim: after
    // the timeout sweep the pot is gone and the late rebate says so plainly.
    function claimNoShowRebate(eid: uint256) public returns (()) {
        match (eventsRec[eid]) {
        case EventRec.NoEvent { revertNotFound(); }
        case EventRec.Ev(rec) {
            requireK(stateOrd(deriveState(cancelledM[eid], rec)) == 3,
                     "NotSettled()");
            let c: Counters = countersM[eid];
            let per = calcRebate(c.registered, c.checkedIn, rec.deposit);
            requireK(per != 0, "NothingToRebate()");
            requireStatus(statusM[eid][caller()], 1);
            requireK(per <= potOf(eid), "PayoutSwept()");

            statusM[eid][caller()] = AttendeeStatus.Rebated;
            // The rebate touches no counter - registeredCount deliberately
            // stays frozen - so the only state change besides the status is
            // the ledger debit.
            payOut(eid, caller(), per);

            emitLog3W1(keccakLit("RebateClaimed(uint256,address,uint256)"),
                       Typedef.rep(eid), Typedef.rep(caller()), Typedef.rep(per));
        }
        }
    }

    // --- organizer flow ---

    // Per-attendee status flip. The check-in window / cancelled gate is applied
    // once by the callers (requireCheckInOpen). Silently skips anyone not
    // currently Registered, so batches tolerate invalid entries. Returns the
    // tally delta (1 = flipped, 0 = skipped): the counters write belongs to
    // the entry points, once per external call, not per attendee.
    function checkInInner(eid: uint256, a: address) returns (uint256) {
        if (statusOrd(statusM[eid][a]) == 1) {
            statusM[eid][a] = AttendeeStatus.CheckedIn;
            emitLog3(keccakLit("CheckedIn(uint256,address)"),
                     Typedef.rep(eid), Typedef.rep(a));
            return 1;
        }
        return 0;
    }

    // The one counters read-modify-write behind both check-in entry points.
    // Skipped entirely when nothing flipped (an all-skips call would otherwise
    // pay a redundant same-value 4-slot write).
    function bumpCheckedIn(eid: uint256, n: uint256) {
        if (n == 0) { return; }
        let c: Counters = countersM[eid];
        countersM[eid] = Counters(c.registered, c.checkedIn + n, c.claimed);
    }

    function checkIn(eid: uint256, a: address) public returns (()) {
        match (eventsRec[eid]) {
        case EventRec.NoEvent { revertNotFound(); }
        case EventRec.Ev(rec) {
            onlyOrganizerOf(rec.organizer);
            requireCheckInOpen(cancelledM[eid], rec);
            bumpCheckedIn(eid, checkInInner(eid, a));
        }
        }
    }

    // --- operators (proof-based check-in) ---
    // An operator holds the same check-in attestation authority as the
    // organizer; appointing one is a trust decision. The bool param decodes
    // strictly (a calldata word above 1 reverts DirtyHigherBitsForBool in
    // std), matching the typed address paths.

    function setOperator(eid: uint256, operator: address, enabled: bool) public returns (()) {
        match (eventsRec[eid]) {
        case EventRec.NoEvent { revertNotFound(); }
        case EventRec.Ev(rec) {
            onlyOrganizerOf(rec.organizer);
            operatorsM[eid][operator] = enabled;
            emitLog3W1(keccakLit("OperatorSet(uint256,address,bool)"),
                       Typedef.rep(eid), Typedef.rep(operator), frombool(enabled));
        }
        }
    }

    // Raw-mapping getter, zero-tier like the stat getters: false for unknown
    // events and unknown addresses alike.
    function isOperator(eid: uint256, a: address) public returns (bool) {
        return operatorsM[eid][a];
    }

    // --- proof-based check-in ---
    // Two EIP-712 signatures replace the organizer transaction: a Ticket
    // signed by the attendee (timeless consent) and a Presence countersigned
    // at the door by the organizer or an operator. ANYONE may submit the pair
    // while check-in is open (requireCheckInOpen in the entry points: the
    // dispute window is the only time bound) - a relayer, the door device
    // once it regains signal, or the attendee themselves.

    // One Ticket + Presence pair. Reverts on anything cryptographically
    // wrong; whether the attendee's status allows the flip is the
    // caller's concern (checkInInner skips silently). std ecrecover
    // pre-zeroes its return scratch and returns a real signer or reverts
    // (MalleableSignatureRejected / ECRecoverFailed) - never a stale scratch
    // word - so no comparison here sees garbage. The domain separator is
    // passed in so a batch hashes it once.
    function verifyProof(eid: uint256, org: address, dom: bytes32,
                         attendee: address,
                         ticketSig: memory<bytes>, presenceSig: memory<bytes>) {
        match (splitSig(ticketSig)) {
        case Sig.Sig(r, s, v) {
            requireK(ecrecover(eip712Digest(dom, hashTicket(eid)), v, r, s) == attendee,
                     "TicketSignerMismatch()");
        }
        }
        match (splitSig(presenceSig)) {
        case Sig.Sig(r, s, v) {
            let signer =
                ecrecover(eip712Digest(dom, hashPresence(eid, attendee)), v, r, s);
            // No short-circuit in the language - both operands always
            // evaluate; both are pure reads, so the fold is safe.
            requireK(signer == org || operatorsM[eid][signer],
                     "PresenceSignerUnauthorized()");
        }
        }
    }

    function checkInWithProof(eid: uint256, attendee: address,
                              ticketSig: memory<bytes>, presenceSig: memory<bytes>) public returns (()) {
        match (eventsRec[eid]) {
        case EventRec.NoEvent { revertNotFound(); }
        case EventRec.Ev(rec) {
            requireCheckInOpen(cancelledM[eid], rec);
            verifyProof(eid, rec.organizer, domainSep(), attendee, ticketSig, presenceSig);
            bumpCheckedIn(eid, checkInInner(eid, attendee));
        }
        }
    }

    // Batch semantics mirror checkInBatch: STATUS-based skips are silent
    // no-ops (already checked in / not registered), but a bad signature or
    // unauthorized presence signer REVERTS the whole batch - that is a
    // malformed submission, not benign state drift. The typed
    // calldata-array parameters decode lazily; the hand-decoded checkInBatch
    // fallback shows what this required before the decoder landed.
    // The first array is NOT named attendees: a parameter sharing a public
    // function's name (the attendees getter) resolves against the function in
    // the term namespace, degrading the parameter's type to an unsolved
    // variable (SC0223 "cannot entail ... RValueIdxAccess").
    function checkInBatchWithProofs(
        eid: uint256,
        toCheck: calldata<array<address>>,
        ticketSigs: calldata<array<memory<bytes>>>,
        presenceSigs: calldata<array<memory<bytes>>>
    ) public returns (()) {
        match (eventsRec[eid]) {
        case EventRec.NoEvent { revertNotFound(); }
        case EventRec.Ev(rec) {
            requireCheckInOpen(cancelledM[eid], rec);
            let n = toCheck.length();
            requireK(ticketSigs.length() == n, "ProofArrayMismatch()");
            requireK(presenceSigs.length() == n, "ProofArrayMismatch()");
            if (n > maxBatchSize()) {
                revertWith2("BatchTooLarge(uint256,uint256)",
                            Typedef.rep(n), Typedef.rep(maxBatchSize()));
            }
            let dom = domainSep();
            let flips = uint256(0);
            for (let i = uint256(0); i < n; i = i + 1) {
                // Bind the element once: calldata indexing re-runs the bounds
                // check and address decode each time, so toCheck[i] twice is
                // wasted work.
                let who = toCheck[i];
                verifyProof(eid, rec.organizer, dom, who, ticketSigs[i], presenceSigs[i]);
                flips = flips + checkInInner(eid, who);
            }
            bumpCheckedIn(eid, flips);
        }
        }
    }

    function cancelEvent(eid: uint256) public returns (()) {
        match (eventsRec[eid]) {
        case EventRec.NoEvent { revertNotFound(); }
        case EventRec.Ev(rec) {
            onlyOrganizerOf(rec.organizer);
            requireK(stateOrd(deriveState(cancelledM[eid], rec)) == 0,
                     "EventAlreadyStarted()");
            cancelledM[eid] = true;
            emitLog2(keccakLit("EventCancelled(uint256)"), Typedef.rep(eid));
        }
        }
    }

    function setMetadataURI(eid: uint256, newUri: memory<string>) public returns (()) {
        match (eventsRec[eid]) {
        case EventRec.NoEvent { revertNotFound(); }
        case EventRec.Ev(rec) {
            onlyOrganizerOf(rec.organizer);
            metadataUris[eid - 1] = newUri;
            emitLog2Str(keccakLit("MetadataUpdated(uint256,string)"),
                        Typedef.rep(eid), newUri);
        }
        }
    }

    // --- dust ---

    function claimDust(eid: uint256) public returns (()) {
        match (eventsRec[eid]) {
        case EventRec.NoEvent { revertNotFound(); }
        case EventRec.Ev(rec) {
            requireK(stateOrd(deriveState(cancelledM[eid], rec)) == 3,
                     "NotSettled()");
            let c: Counters = countersM[eid];
            // A zero-check-in settlement is abandonment, not dust: the pot
            // is exactly the attributed deposits and belongs to claimRefund
            // (which never expires), so there is no sweep - mirroring
            // cancelled events. Without this gate the vacuous 0 == 0
            // "all claimed" would let the maintainer race the refunds.
            requireK(c.checkedIn != 0, "DustNotClaimable()");
            // When the reward cap leaves a rebate pool, the early
            // "all claimed" door stays shut - there is no rebated-count
            // tally, so before the timeout the pot may still owe
            // no-shows their rebates. The 30-day sweep then takes
            // whatever rebates went unclaimed, like unclaimed payouts.
            let allClaimed = c.claimed == c.checkedIn
                && calcRebate(c.registered, c.checkedIn, rec.deposit) == 0;
            let timeoutPassed = timeNow() > addCk(addCk(rec.eventEnd, rec.disputePeriod),
                                                  dustClaimTimeout());
            if (!allClaimed && !timeoutPassed) {
                fail("DustNotClaimable()");
            }
            // The per-event pot IS the dust once every claim is out; no
            // reliance on the shared contract balance. Draining it in full
            // through payOut zeroes the pot - no counter changes here at all.
            let dust = potOf(eid);
            requireK(dust != 0, "DustNotClaimable()");
            payOut(eid, maintainer, dust);

            emitLog3W1(keccakLit("DustClaimed(uint256,address,uint256)"),
                       Typedef.rep(eid), Typedef.rep(maintainer), Typedef.rep(dust));
        }
        }
    }

    // --- maintainer ---

    function setMaintainer(newMaintainer: address) public returns (()) {
        requireK(caller() == maintainer, "NotAuthorized()");
        if (Typedef.rep(newMaintainer) == 0) {
            revertStr("InvalidEventParameters(string)", "Zero address");
        }
        if (newMaintainer == maintainer) {
            revertStr("InvalidEventParameters(string)", "Same maintainer");
        }
        let old = maintainer;
        maintainer = newMaintainer;
        emitLog3(keccakLit("MaintainerUpdated(address,address)"),
                 Typedef.rep(old), Typedef.rep(newMaintainer));
    }

    // --- fallback: stray-ETH rejection + checkInBatch manual dispatch ---

    // checkInBatch(uint256,address[]) predates lazy calldata-array decoding
    // and stays hand-decoded deliberately: wire compat, the stray-ETH
    // rejection lives in this same fallback, and it is the exhibit of what
    // pre-decoder Core Solidity required. Plain ETH transfers (empty
    // calldata) and unknown selectors revert.
    function checkInBatchImpl() {
        let eid = uint256(calldataload(4));
        match (eventsRec[eid]) {
        case EventRec.NoEvent { revertNotFound(); }
        case EventRec.Ev(rec) {
            onlyOrganizerOf(rec.organizer);
            requireCheckInOpen(cancelledM[eid], rec);
            let lenPtr = 4 + calldataload(36); // second arg head holds the array offset
            let len = calldataload(lenPtr);
            // len is a raw calldata word, so unwrap the cap once for both the
            // comparison and the revert argument.
            let maxB = Typedef.rep(maxBatchSize());
            if (len > maxB) {
                revertWith2("BatchTooLarge(uint256,uint256)", len, maxB);
            }
            // Flips accumulate across the loop; the counters record is
            // read-modified-written ONCE after it, not per attendee.
            let flips = uint256(0);
            for (let i: word = 0; i < len; i = i + 1) {
                let w = calldataload(lenPtr + 32 + i * 32);
                // Strict ABI decoding, matching the std decoder on the typed
                // path (checkIn): an address word with dirty upper bits
                // reverts instead of silently no-oping into an unset mapping
                // key. Same error the std uses, so both paths are uniform.
                requireK(shr(160, w) == 0, "DirtyHigherBitsForAddress()");
                flips = flips + checkInInner(eid, address(w));
            }
            bumpCheckedIn(eid, flips);
        }
        }
    }

    fallback() payable {
        let sz = calldatasize();
        requireK(sz != 0, "TransferFailed()");
        if (sz >= 4) {
            if (shr(224, calldataload(0)) == shr(224, keccakLit("checkInBatch(uint256,address[])"))) {
                if (callvalue_() != 0) {
                    revertEmpty();
                }
                checkInBatchImpl();
                return;
            }
        }
        revertEmpty();
    }
}
