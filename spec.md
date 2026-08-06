# Kodyl - Decentralized Event Management

> Skin in the game incentives for event attendance.

## Overview

Kodyl is a decentralized event management protocol where attendees stake a small deposit when signing up for an event. Show up and get your deposit back (plus a share of no-show deposits). Don't show up without canceling? You lose your stake.

This is a reimplementation/evolution of [Kickback](https://kickback.events/), designed as an educational open-source public good. This document is the language-agnostic protocol reference: the rules and the rationale. The implementation lives in `core/` (Core Solidity); `core/README.md` covers the implementation design and its deviations, and `core/COVERAGE.md` maps every mechanic and invariant here to a test.

## Core Mechanics

### Happy Path

1. **Organizer creates event** - Sets deposit amount, cancellation deadline, event time, capacity; receives the new event's id
2. **Attendees register** - Stake the required deposit (exact amount)
3. **Event happens** - Attendees check in (verified by organizer)
4. **Settlement** - Attendees claim deposits + pro-rata share of no-show deposits

### Cancellation

- Attendees can cancel and get their deposit back **immediately** up until the cancellation deadline (deadline timestamp inclusive)
- Cancellation deadline is configurable per event (minimum: 2 hours before event start)
- After the deadline: no refund unless the event is cancelled by the organizer
- Registration stays open after the deadline (until event start) - registering in that window means no self-service exit
- Re-registration after cancellation is allowed (requires a new deposit)

### No-Shows

- Attendees who neither cancel nor check in forfeit their deposit
- Forfeited deposits are distributed pro-rata among checked-in attendees
- If nobody checks in, the event settles as **abandoned**: every registered attendee can reclaim their deposit in full (`claimRefund`, forever - see Settlement)

### Event Cancellation

- Organizer can cancel the entire event, entitling every registered attendee to a full refund (`claimRefund`, pull-based)
- Event cancellation only allowed **before the event starts** (`block.timestamp < eventStart`)
- After the event starts, the organizer cannot cancel (only individual claims after the dispute period)
- Refunds on a cancelled event **never expire** (see Settlement)

## Architecture

### Singleton

**One contract holds every event.** An event is a record stored behind a sequential 1-based id; creating an event is a state write that returns the id, not a contract deployment.

```
Kodyl (singleton)
├── createEvent(...) -> eventId      // state write, sequential ids from 1
├── Per-event records: parameters, cancelled flag, attendee statuses, tallies
├── Per-event pot (held) + global ledger (totalHeld)
└── Maintainer address (dust recipient, rotatable)
```

The concept started from the classic factory shape - one deployed contract per event - whose appeal is isolation: a per-event contract cannot confuse its funds or state with another event's, and its balance is its pot. The singleton keeps those properties by construction instead of by deployment: every piece of state is typed and keyed by the event id (statuses, tallies, flags), and fund isolation is explicit ledger accounting rather than separate balances. What the singleton buys: creating an event costs a state write instead of a deployment, and there is a single address to index, read, and reason about.

**Shared custody is the central trade.** All deposits live in one contract balance. The accounting that earns back per-event isolation:

- `held[eid]` - the per-event pot: deposits in; refunds, payouts, and dust out
- `totalHeld` - the global ledger: the sum of all pots
- After every ETH movement the contract asserts `address(this).balance >= totalHeld`

The direction is `>=`, not `==`: forced ETH (selfdestruct, block-reward payments) can raise the balance without executing any code and **cannot be rejected**, so strict equality would let 1 wei of forced ETH permanently brick every flow of every event. Forced surplus is simply unowned and stuck; the ledger ignores it.

### Roles

**Organizer** (per-event, permissionless)
- Whoever calls `createEvent` is the organizer of that event - there is no global admin
- Checks in attendees (single or batch), or signs `Presence` for the proof-based path
- Authorizes and revokes door operators (`setOperator`)
- Can cancel the event before it starts (entitles all registered attendees to refunds)
- Can approve late check-ins during the dispute period
- Can update the event's metadata URI at any time

**Operator** (per-event, appointed by the organizer)
- Authorized and revoked on-chain per event via `setOperator`
- Can sign a valid `Presence` attestation - the **same check-in authority as the organizer**, and nothing more (cannot cancel, change parameters, or move funds)

**Attendee**
- Registers with the exact deposit
- Can cancel through the deadline (immediate refund)
- Can re-register after cancelling
- Claims deposit + reward after the dispute period ends, or a refund if the event was cancelled or settled abandoned (zero check-ins)

**Maintainer** (one address, protocol-level)
- Receives per-event dust and timed-out unclaimed payouts
- Can hand the role to a new address (`setMaintainer`); no power over event funds, parameters, or check-ins

## Event Lifecycle

### Timestamp-Derived State

Instead of storing an explicit state enum, an event's state is **derived from timestamps** (plus the cancelled flag). This eliminates state transition bugs and reduces storage.

```solidity
function getState(uint256 eid) public view returns (State) {
    // eventStart / eventEnd / disputePeriod are fields of event eid
    if (cancelled[eid]) return State.Cancelled;
    if (block.timestamp < eventStart) return State.Registration;
    if (block.timestamp <= eventEnd) return State.Active;
    if (block.timestamp <= eventEnd + disputePeriod) return State.Dispute;
    return State.Settled;
}
```

Boundary semantics are exact and tested at every edge:

- `Registration` ends the instant the event starts: at `t == eventStart` the state is already `Active`
- `Active` includes both endpoints: `eventStart <= t <= eventEnd`
- `Dispute` includes its back edge: at exactly `eventEnd + disputePeriod` the state is still `Dispute` (claims still revert); `Settled` begins one second later
- The cancellation deadline is inclusive: `cancel` works at exactly `t == cancellationDeadline`
- The dust timeout is exclusive: the sweep opens strictly after `eventEnd + disputePeriod + 30 days`

### States and Allowed Actions

| State | Condition | Actions Allowed |
|-------|-----------|-----------------|
| `Registration` | `now < eventStart` | Register, cancel (through the deadline), organizer cancel event, set metadata URI |
| `Active` | `eventStart <= now <= eventEnd` | Check-ins (single/batch), set metadata URI |
| `Dispute` | `eventEnd < now <= eventEnd + disputePeriod` | Late check-ins by organizer, set metadata URI |
| `Settled` | `now > eventEnd + disputePeriod` | Claims (until swept - late claims revert `PayoutSwept`), dust withdrawal, set metadata URI; with zero check-ins: refund claims instead (forever, no dust) |
| `Cancelled` | `cancelled == true` | Refund claims (forever), attendee cancel (through the deadline), set metadata URI |

Notes on the two rows that are easy to get wrong:

- `setMetadataURI` is organizer-only and deliberately state-independent: metadata stays correctable in **every** state, including `Settled` and `Cancelled`.
- On a cancelled event, an attendee's own `cancel` still works until the cancellation deadline - it does not check the cancelled flag. It is funds-safe (same refund as `claimRefund`) but emits `RegistrationCancelled` rather than `RefundClaimed`. This is deliberate: the deadline window is exactly when self-service cancel is a promised right, and cancellation of the event should not revoke it. After the deadline, `claimRefund` is the (permanent) path. Cancelling an already-cancelled event reverts.

### Capacity

Registration closes automatically when `registeredCount == maxAttendees` (if `maxAttendees > 0`; 0 means unlimited). A cancellation frees the slot. No explicit "close registration" action needed.

## Data Model

### Event Record (set at creation, immutable)

| Field | Type | Notes |
|-------|------|-------|
| `organizer` | `address` | Event creator, has per-event admin rights |
| `depositAmount` | `uint256` | Required stake in wei |
| `cancellationDeadline` | `uint256` | Timestamp, min 2h before event start |
| `eventStart` | `uint256` | Event start timestamp |
| `eventEnd` | `uint256` | Event end timestamp |
| `disputePeriod` | `uint256` | Duration after event end, bounded 1 hour to 30 days |
| `maxAttendees` | `uint256` | Capacity cap (0 = unlimited) |

Alongside the record, per event:

| Field | Mutable | Notes |
|-------|---------|-------|
| `metadataURI` | Yes | IPFS hash or URL; organizer can change in any state, emits an event |
| `cancelled` | Once | Set true by organizer cancel, never unset |

Creation validates: `depositAmount > 0`; `eventStart` in the future; `eventEnd > eventStart`; `cancellationDeadline + 2 hours <= eventStart` and the deadline in the future; `disputePeriod` within `[1 hour, 30 days]` (a zero window would strand late-but-present attendees; an unbounded one would lock funds for years).

### Attendee Status

An enum per (event, attendee) prevents invalid transitions:

```solidity
enum AttendeeStatus {
    None,       // Never registered
    Registered, // Deposited, not yet checked in
    Cancelled,  // Cancelled or refunded, deposit returned
    CheckedIn,  // Verified attendance
    Claimed     // Already claimed payout
}
```

**Valid transitions:**
- `None → Registered` (register, Registration state only)
- `Registered → Cancelled` (cancel through the deadline, or claimRefund on a cancelled or abandoned event)
- `Registered → CheckedIn` (organizer check-in, Active or Dispute)
- `Cancelled → Registered` (re-register with a new deposit; only while the state is Registration, so impossible once the event has started or been cancelled)
- `CheckedIn → Claimed` (claim at Settled, if the pot has not been swept)

**Invalid transitions (revert):**
- `Claimed → anything` (terminal - no re-registration after claiming)
- `CheckedIn → Cancelled` (can't cancel after check-in)
- `CheckedIn → Registered` (can't re-register after check-in)
- `Registered → Registered` (already registered)

### Counters (per event)

| Counter | Updated By |
|---------|------------|
| `registeredCount` | +1 on register, -1 on cancel and on claimRefund |
| `checkedInCount` | +1 on check-in |
| `claimedCount` | +1 on claim |
| `held` | + deposits, - refunds/payouts/dust (the per-event pot) |

Note: `registeredCount` tracks *current* registrations (not historical). Cancelled and refunded attendees are subtracted.

### Computed at Settlement

| Value | Calculation |
|-------|-------------|
| No-shows | `registeredCount - checkedInCount` |
| Total forfeited | `noShowCount * depositAmount` |
| Reward per attendee | `checkedInCount > 0 ? totalForfeited / checkedInCount : 0` (floor division) |
| Attendee payout | `depositAmount + rewardPerAttendee` |
| Dust | Whatever remains in the event's pot after all claims (`totalForfeited % checkedInCount` when everyone claims) |

Both counts are frozen once the event settles (no registration, cancellation, or check-in can occur), so every claimer receives the same payout. During Dispute, each late check-in moves the projected reward (fewer no-shows, more claimants) - the number is not final until Settled.

### Read Surface

Two deliberate tiers:

- **Record-backed getters** - `getEvent` (all 7 parameters), `organizer`, `getState`, `metadataURI`, `rewardPerAttendee` - revert `EventNotFound` for an unknown id: they answer questions that are meaningless without an event.
- **Mapping-backed getters** - `attendees` (status), `cancelled`, `registeredCount`, `checkedInCount`, `claimedCount`, `held` - return zero for an unknown id, mirroring Solidity public-mapping semantics.

Global reads: `eventCount`, `totalHeld`, `maintainer`, and the protocol constants (`MAX_BATCH_SIZE`, `DUST_CLAIM_TIMEOUT`, `MIN_CANCELLATION_BUFFER`).

## Check-in

### Methods

Two methods for organizer check-in, both taking the event id:

1. **Single check-in** - `checkIn(uint256 eid, address attendee)`
2. **Batch check-in** - `checkInBatch(uint256 eid, address[] calldata attendees)`

### Batch Check-in Constraints

- Maximum 100 attendees per batch; larger arrays revert `BatchTooLarge` (prevents gas limit issues)
- Skips invalid entries (not registered, already checked in, cancelled) without reverting - the batch is best-effort
- An address word with dirty upper bits reverts (strict ABI decoding, matching the single check-in path) instead of silently no-oping into an unset key
- Emits an individual `CheckedIn` event per newly checked-in attendee for indexing

```solidity
function checkInBatch(uint256 eid, address[] calldata attendees) external onlyOrganizer(eid) {
    if (attendees.length > MAX_BATCH_SIZE) revert BatchTooLarge(attendees.length, MAX_BATCH_SIZE);
    for (uint256 i = 0; i < attendees.length; ++i) {
        _checkIn(eid, attendees[i]); // skips anyone not currently Registered
    }
}
```

### Check-in Window

Check-ins are valid from `eventStart` through `eventEnd + disputePeriod` (both edges inclusive) - the `Active` and `Dispute` states. This lets organizers approve late check-ins for attendees who were present but missed the initial window; every late check-in shifts the projected reward until settlement.

The gate is the derived state, not a raw time window: a cancelled event is never in `Active` or `Dispute`, so **check-ins on a cancelled event always revert**. (Otherwise an attendee could be flipped to `CheckedIn` after cancellation and lose the refund path.)

### Proof-based Check-in (v2)

The direct methods above need the organizer online at the door: a transaction per
scan, gas and signal at the venue, and nothing settles if the organizer never
submits. The proof-based path decouples the physical check-in from the on-chain
write with **two EIP-712 signatures**, so anyone can submit the pair later.

**The two messages** (type strings verbatim - the off-chain signer must byte-match
them; the EIP-712 domain is name `Kodyl`, version `1`, the deployment's `chainId`
and contract address):

- `Ticket(uint256 eventId)` - signed by the **attendee's** wallet, once, any time
  before or during the event. It proves control of and consent by the registered
  address. Timeless: no expiry, no attendee address in the payload (the recovered
  signer *is* the binding, and the contract requires it to equal the claimed
  attendee).
- `Presence(uint256 eventId,address attendee)` - signed at the
  door by the **organizer or an authorized operator**, after seeing a body.

**Who submits.** Either signature alone does nothing on-chain. Given the pair,
*anyone* may submit it while check-in is open - a relayer, the operator's device
once it regains signal, or the attendee themselves (self-rescue). Submission is
not access-controlled because the two signatures are the authorization.

```solidity
checkInWithProof(uint256 eid, address attendee, bytes ticketSig, bytes presenceSig)
checkInBatchWithProofs(uint256 eid, address[] attendees,
                       bytes[] ticketSigs, bytes[] presenceSigs)
```

Each pair is verified: the event exists and check-in is open (`Active`/`Dispute`,
same gate as the direct path); the ticket signer equals `attendee` else
`TicketSignerMismatch`; the presence signer is the organizer or an operator else
`PresenceSignerUnauthorized`. Then the same idempotent flip as the direct path
(already-checked-in or not-registered is a silent no-op).

A proof is submittable throughout the dispute window (the on-chain check-in
gate); there is **no separate proof expiry**. A `Presence` submission is
idempotent and moves no funds, cross-event and cross-chain replay are blocked
by the EIP-712 domain plus the `eventId` in both structs, and after
`eventEnd + disputePeriod` the state is `Settled` and every check-in reverts
`CheckInWindowClosed` - so a second per-proof clock would buy nothing.

**Signatures** are the 65-byte `r || s || v` form a wallet's `signTypedData`
returns. Recovery uses the standard `ecrecover`, which **reverts** on a malformed
signature rather than returning zero (`MalleableSignatureRejected` for the high-s
form, `ECRecoverFailed` for an unrecoverable one). A wrong-length signature reverts
`InvalidSignatureLength`.

**Batch revert-vs-skip.** The batch mirrors `checkInBatch`'s philosophy with one
sharp distinction: status-based skips (not registered, already checked in) stay
**silent no-ops**, but any **signature or authorization failure reverts
the whole batch** - a bad proof is a malformed submission, not benign state drift.
Array-length mismatches revert `ProofArrayMismatch`; the 100-entry `MAX_BATCH_SIZE`
cap applies as for the direct batch.

**Operators.** An event's organizer may authorize door operators on-chain:

```solidity
setOperator(uint256 eid, address operator, bool enabled)  // organizer-only, emits OperatorSet
isOperator(uint256 eid, address addr) -> bool             // zero-tier: false for unknown ids
```

An operator's Presence signature carries the **same check-in authority as the
organizer's**. Every change emits `OperatorSet(uint256,address,bool)`. The
`enabled` parameter decodes strictly: a calldata word above 1 reverts
`DirtyHigherBitsForBool`, matching the strict address decoding on the typed
paths.

**Ticket sharing is tolerated, not marketed.** A Ticket signature can be forwarded
to a friend - there is deliberately no anti-share binding, freshness, or liveness
mechanic. The human at the door is the real check: the operator signs `Presence`
only after seeing a body. That trust in the door is accepted and stays. (This is
why the original "self-check-in via QR" idea below, rejected for being too easy to
share, is safe here: the presence attestation, not the ticket, is the gate.)

## Settlement

### Claiming (Pull Pattern)

Attendees claim their own payout after the dispute period ends:

```solidity
function claim(uint256 eid) external {
    require(getState(eid) == State.Settled, NotSettled());
    require(status[eid][msg.sender] == AttendeeStatus.CheckedIn, InvalidAttendeeStatus());

    uint256 payout = depositAmount + rewardPerAttendee(eid);
    require(payout <= held[eid], PayoutSwept()); // pot already swept after the timeout

    status[eid][msg.sender] = AttendeeStatus.Claimed;
    claimedCount[eid]++;
    held[eid] -= payout;
    totalHeld -= payout;

    send(msg.sender, payout);
    assert(address(this).balance >= totalHeld);
}
```

**Why pull-only (no `settleAll()`):**
- Gas-safe: no risk of hitting the block gas limit with large attendee lists
- Simpler: no pagination logic needed
- Fair: each attendee pays their own gas

### Dust Handling

Due to floor division, some wei may remain after all claims. Example:
- 3 attendees checked in
- 10 wei forfeited from no-shows
- Each gets 3 wei reward (10 / 3 = 3)
- 1 wei dust remains (10 % 3 = 1)

`claimDust(eid)` can be called by anyone once the event is settled **with at
least one check-in** and either every checked-in attendee has claimed or a
30-day timeout has passed. Dust is **the event's own pot** - exact per-event
accounting, never a reading of the shared contract balance - and goes to the
project maintainer.

```solidity
function claimDust(uint256 eid) external {
    require(getState(eid) == State.Settled, NotSettled());
    require(checkedInCount[eid] != 0, DustNotClaimable()); // abandoned pots refund, never sweep
    require(claimedCount[eid] == checkedInCount[eid]
         || block.timestamp > eventEnd + disputePeriod + 30 days, DustNotClaimable());

    uint256 dust = held[eid];              // the per-event pot
    require(dust != 0, DustNotClaimable());
    held[eid] = 0;
    totalHeld -= dust;
    send(maintainer, dust);
}
```

**The timeout sweep takes unclaimed payouts too.** After the 30-day timeout the whole remaining pot - rounding dust *and* the payouts of checked-in attendees who never claimed - goes to the maintainer. A checked-in attendee who shows up later is told plainly: `claim` reverts `PayoutSwept()` (rather than underflowing into an opaque panic). Claim within 30 days of settlement or forfeit to the maintainer - that is the protocol's abandonment rule.

### Zero Check-ins: Abandonment

An event that settles with `checkedInCount == 0` is **abandoned**. On-chain
this is indistinguishable from a fake event, a door that never happened, or a
venue disaster - so the fail-safe outcome is chosen: every still-registered
attendee can `claimRefund` their full deposit, forever, exactly as on a
cancelled event. Nobody profits from an abandoned event: not the organizer
(no payout path), and deliberately not the maintainer either.

Mechanically: `rewardPerAttendee` is defined as 0 (no division by zero), the
refund gate opens only at `Settled` (during `Active`/`Dispute` the organizer
may still check people in - a single late check-in flips the event into
normal settlement and the refund path never opens), and `claimDust` refuses
zero-check-in events outright. Without that refusal, "all claimed" would be
vacuously true (0 == 0) and the maintainer could race the refunds.

### No Sweep for Cancelled or Abandoned Events

Cancelled and abandoned events have **no dust path and no timeout**: for a
cancelled event `claimDust` requires the `Settled` state it never reaches;
for an abandoned one it refuses `checkedInCount == 0`. In both, `claimRefund`
works forever. This is deliberate. Both pots are exactly the sum of
attributed deposits - there is no rounding dust and no forfeiture to abandon -
so a sweep would convert funds that are today fail-safe (locked at worst,
stealable by no one) into a maintainer seizure surface. Refunds never expire.

## Invariants

These MUST hold at all times - test with fuzzing:

1. **Deposit accounting**: The contract balance always covers the deposit ledger
   - In-contract: `address(this).balance >= totalHeld`, asserted after every ETH movement, where `totalHeld` is the sum of all per-event pots
   - The direction is `>=`, not `==`: forced ETH (selfdestruct, block rewards) cannot be rejected, and strict equality would let 1 wei of forced ETH brick every flow
   - The test harness proves the tight form `balance == totalHeld + forcedETH` under a fuzzed forced-ETH regime

2. **No double claims**: `Claimed` status is terminal (no transitions out)

3. **No post-deadline cancellation**: `cancel(eid)` reverts if `block.timestamp > cancellationDeadline`

4. **Claims only after dispute period**: `claim(eid)` reverts unless `getState(eid) == Settled`

5. **Check-in window enforced**: Check-ins revert unless the derived state is `Active` or `Dispute` (from `eventStart` through `eventEnd + disputePeriod`; never on a cancelled event)

6. **Event cancellation window**: `cancelEvent(eid)` reverts if `block.timestamp >= eventStart` (and on an already-cancelled event)

## Security Considerations

### FREI-PI Pattern

All state-changing functions follow:
- **F**unction requirements (validate inputs, check state)
- **E**ffects (update state)
- **I**nteractions (external calls last - CEI)
- **P**rotocol **I**nvariants (assert `balance >= totalHeld` after every ETH movement)

No reentrancy guard: status transitions are terminal and flip before any send (CEI), which the adversarial suite attacks directly (reentrant claim, claimDust, cross-event cancel).

### ETH Handling

- Plain ETH transfers (empty calldata) and unknown selectors are rejected by the fallback
- Forced ETH (selfdestruct, block rewards) cannot be rejected by any contract; the `>=` ledger direction absorbs it - the surplus is unowned and stuck, and no flow is affected
- All ETH transfers use the CEI pattern; payouts, refunds, and dust are debited from the per-event pot and the global ledger before sending

### Trust Assumptions

**Check-in authority is custody.** The organizer decides who checked in, and check-in status is what money follows - so attendees trust the organizer with their stake, not merely with attendance bookkeeping:

- **An organizer can capture honest deposits.** Register a sybil, check in only the sybil: with 10 honest attendees at 1 ETH each, the sybil claims 11 ETH at settlement (its own deposit plus all 10 forfeitures). No protocol rule prevents this.
- **An organizer who checks in nobody achieves nothing** - a zero-check-in settlement is abandonment: every attendee reclaims their deposit in full and no sweep exists. (Checked-in-but-unclaimed payouts still sweep to the maintainer after 30 days - that rule is about claimant abandonment, not organizer abuse.)
- Mitigations are economic and reputational only: an organizer who does this burns their ability to run future events. A future organizer-stake mechanism could add a slashing cost.

What the organizer *cannot* do: change any event parameter after creation, take custody directly (no payout path pays the organizer as such), cancel after the event starts, block a pre-deadline cancel, or block refunds on a cancelled event.

**Operators inherit the check-in authority.** An authorized operator can sign a valid `Presence`, so the sybil-check-in surface above extends to every operator the organizer appoints: an operator can attest presence for a sock puppet exactly as the organizer can. **Appointing an operator is therefore a trust decision equivalent to sharing the organizer's check-in power** - not a lesser delegation. The set is on-chain and verifiable (`isOperator`, the `OperatorSet` log), and revocable at any time (`setOperator`), so the trust is auditable and retractable, but while an operator is authorized their attestations carry full weight. What an operator still cannot do matches the organizer's own limits: no parameter changes, no direct custody, no cancellation.

**Maintainer liveness.** The maintainer is assumed to accept plain ETH. A maintainer contract that reverts on receipt blocks only dust egress - `claim`, `cancel`, and `claimRefund` pay the caller and are unaffected - and the situation is self-healing via `setMaintainer`. (Validation failures in `setMaintainer` and construction reuse the `InvalidEventParameters(string)` error shape - a deliberate wire-compatibility choice, see `core/README.md`.)

### Attack Vectors

| Attack | Outcome / Mitigation |
|--------|----------------------|
| Organizer sybil check-in (register a sock puppet, check in only it) | **Not prevented** - the sybil claims the whole pot. Economic/reputational deterrence only; future: organizer stake |
| Operator sybil check-in (an authorized operator attests presence for a sock puppet) | **Not prevented** - same surface as the organizer; appointing an operator grants the organizer's check-in power. On-chain, auditable (`isOperator`), revocable (`setOperator`) |
| Ticket sharing (an attendee forwards their signed `Ticket` to a friend) | **Tolerated by design** - no anti-share binding. The human at the door gates check-in: an operator signs `Presence` only after seeing a body |
| Forged / replayed proof (wrong signer, wrong event, wrong chain) | Rejected on-chain: `TicketSignerMismatch`, `PresenceSignerUnauthorized`, or domain-mismatch (recovers a different signer). Malformed signatures revert (`MalleableSignatureRejected` / `ECRecoverFailed` / `InvalidSignatureLength`); after the dispute window every check-in reverts `CheckInWindowClosed` |
| Organizer checks in nobody | **Defused** - zero-check-in settlement is abandonment: full refunds forever, no sweep, nobody profits |
| Front-running check-ins | Not profitable - check-in doesn't transfer value |
| Reentrancy on claim/refund/dust | CEI + terminal status transitions; attacked directly in the accounting suite |
| Griefing via spam registrations | The deposit itself is the spam cost |
| Plain ETH sent to contract | Rejected by the fallback |
| Forced ETH (selfdestruct, block rewards) | Cannot be rejected; absorbed by the `>=` ledger direction, no flow affected |
| Maintainer that reverts on receive | Blocks only dust egress; recoverable via `setMaintainer` |

The economics of the "not prevented" rows - exact payoffs, attacker costs, and
on-chain footprints - are quantified in `ECONOMICS.md`, with every number
verified against the bytecode by `test/KodylEcon.t.sol`.

## MVP Scope

### In Scope

- [x] Singleton contract: every event a record behind a sequential 1-based id, creation a state write
- [x] Timestamp-derived lifecycle (no stored state enum)
- [x] ETH deposits (native currency), exact-amount registration
- [x] Attendee status enum (None/Registered/Cancelled/CheckedIn/Claimed)
- [x] Registration with capacity limit (0 = unlimited, cancellation frees the slot)
- [x] Cancellation with immediate refund (deadline-inclusive)
- [x] Re-registration after cancellation
- [x] Manual check-in by organizer only (single and batch, max 100 per batch)
- [x] Proof-based check-in (EIP-712 `Ticket` + `Presence`; anyone submits while check-in is open - the dispute window is the only time bound; single and batch)
- [x] On-chain door operators per event (`setOperator`/`isOperator`)
- [x] Pro-rata distribution of no-show deposits
- [x] Dispute period for late check-in approval (bounded 1 hour to 30 days)
- [x] Event cancellation with full refunds (before start only; refunds never expire)
- [x] Pull-only claims (no `settleAll()`)
- [x] Per-event dust to the project maintainer; 30-day timeout sweep with `PayoutSwept` for late claims
- [x] Zero-check-in settlement is abandonment: full refunds forever, no sweep (the fail-safe for fake events, no-show doors, and force majeure)
- [x] Rotatable maintainer (`setMaintainer`)
- [x] Metadata URI mutable in every state (emits event on change)
- [x] Plain ETH sends rejected via the fallback; forced ETH absorbed by the ledger
- [x] Per-chain deployment records (`deployments/`)

### Out of Scope (Future Enhancements)

- [ ] ERC20 token deposits
- [ ] DeFi integrations (yield on deposits via PoolTogether, Aave, etc.)
- [ ] Alternative distribution models:
  - Lottery (lucky winner takes all no-show pool)
  - Annual yield payout (deposits earn yield, distributed periodically)
  - Weighted distribution (early registrants get more)
- [ ] DAO governance for protocol-level decisions
- [ ] Protocol fees
- [ ] Privacy features (ZK proofs for attendance without revealing identity)
- [ ] Pure self-check-in with no door attestation (rejected as too easy to share; the proof-based path keeps the human at the door via the operator's `Presence` signature)
- [ ] EIP-1271 contract signers for `Presence` (a door operator that is a multisig - the natural v3; see `CHECKIN-PLAN.md`)
- [ ] Reputation/history tracking across events
- [ ] POAP integration (auto-distribute POAPs to checked-in attendees via POAP API)
- [ ] Multi-sig organizer support
- [ ] Organizer stake (slashing cost for the sybil check-in surface above)

---

## Frontend

The frontend lives in this repo (`frontend/`): a React + viem demo dApp structured around the roles the contract actually has (see `frontend/README.md` and `frontend/ROLES-PLAN.md`).

What exists:

- **Role lenses, not an admin panel**: Discover (browse and register), My tickets (your events grouped by what needs doing), Organize (create and manage your events - organizer controls appear contextually), and a full Event page with an attendee roster reconstructed from event logs
- **State communication**: derived-state labels, countdowns to the next lifecycle boundary, and explicit dispute messaging ("claims open at settlement: the organizer can still approve late check-ins")
- **Identity toggle**: demo accounts (impersonated anvil keys, best for talks) or a real injected wallet; all demo affordances - account picker, chain-clock fast-forward, demo drawer - are chain-gated to local anvil and disappear on real networks
- **Structured metadata** encoded into on-chain `data:` URIs behind a single resolver seam that also understands `http(s)` and `ipfs://`
- **Proof-based check-in**: an attendee signs a `Ticket` once and shows it as a QR code or copyable text; the organizer or an operator scans/pastes it in a Door tab, countersigns `Presence`, and submits the pair (or a stranded attendee self-rescues from the mailbox relay). The bundled `mailbox/` service (zero-dependency Node HTTP relay) carries the operator's half to the attendee; it is trust-free, since the contract verifies both signatures
- **Check-in reminder banner**: a prominent warning banner (top of My tickets, per event, and on the event page) for a still-registered attendee - "confirm your waiting check-in on-chain" with the submit button whenever a countersigned voucher waits in the mailbox, or "contact the organizer before the dispute window closes" once the event has ended with no voucher. During the event with no voucher it stays quiet (showing the ticket at the door is the normal path)
- **Operators management**: the organizer's event page carries a Door operators panel (add / remove / list, the current set reconstructed from `OperatorSet` logs); an appointed operator sees the Door on the event page and countersigns with their own key

Still aspirational (tracked in `frontend/ROLES-PLAN.md`): an edit-metadata UI, a `setMaintainer` control, real IPFS metadata hosting, search/filters, share links, calendar export, and an indexer if log-scanning gets slow.

---

## Testing Strategy

The suite drives the compiled bytecode through a typed interface in forge and asserts selectors, event topics, and revert payloads byte-for-byte:

- **Unit and boundary tests** - every mechanic, every state edge (deadline inclusive, dispute back edge, batch max), access control, capacity, re-registration
- **Adversarial batch-decoder tests** - the `checkInBatch` calldata path attacked with malformed byte strings (truncated words, wild offsets, dirty address bits)
- **Phase-aware invariant fuzzing** - 128k-call campaigns across concurrent events with a forced-ETH regime and an independent ghost model asserting payout exactness per claim
- **Conservation and reentrancy suites** - indivisible-amount splits, three-way ledger equality, reentrant claim/dust/cancel attacks
- **Toolchain canaries** - minimal tests pinning the language behaviors the implementation leans on

`core/COVERAGE.md` is the map: every mechanic, transition, and invariant in this document, with the tests that verify it.

### Deployment

- Public testnet (Sepolia) via guarded scripts; committed per-chain records in `deployments/` (see `VERIFICATION.md` for third-party verification)
- Local anvil for development and the demo frontend

---

## References

- [Kickback (original implementation)](https://kickback.events/)
- [PoolTogether (prize savings protocol)](https://pooltogether.com/)
- [The Pragmatic Programmer - Tracer Bullets](https://pragprog.com/titles/tpp20/the-pragmatic-programmer-20th-anniversary-edition/)
