// SPDX-License-Identifier: MIT
pragma solidity ^0.8.33;

import {Test} from "forge-std/Test.sol";
import {console2} from "forge-std/console2.sol";
import {CoreDeploy} from "./CoreDeploy.sol";
import {IKodyl} from "./Kodyl.t.sol";

/// @notice Drives the FULL lifecycle (register / cancel / claimRefund / check-in
///         / claim / dust / cancelEvent) across three concurrent events with
///         staggered schedules, advancing time, from a bounded actor set.
///
/// Success is engineered, not accidental: each action first scans the (event,
/// actor) space for a pair whose ghost-modelled state lets the call succeed,
/// falling back to a purely seed-derived pick when none qualifies - the revert
/// paths still deserve fuzz. warpToNextPhase jumps just past the next lifecycle
/// boundary of a seed-chosen event, so runs actually reach the check-in, claim,
/// and dust-sweep surface instead of starving in a long-settled world.
///
/// Beyond wei conservation, the handler keeps an independent ghost model of
/// the protocol (per-(event, actor) status, per-event registered / checked-in
/// counts) and, on every successful claim, compares the claimant's balance
/// delta against the model's payout: deposit + min(floor(noShow * deposit /
/// checkedIn), deposit) - the reward is capped at one deposit, with the
/// excess rebated pro-rata to no-shows (claimNoShowRebate, checked the same
/// way). Mismatches are recorded, not asserted, because a failed assert
/// inside a handler is just another swallowed revert under
/// fail_on_revert = false; the parent's invariant_claimPayoutsExact and
/// invariant_rebatePayoutsExact assert.
contract LifecycleHandler is Test {
    // Attendee status ordinals, mirroring the contract's AttendeeStatus ADT.
    uint8 internal constant ST_NONE = 0;
    uint8 internal constant ST_REGISTERED = 1;
    uint8 internal constant ST_CANCELLED = 2;
    uint8 internal constant ST_CHECKED_IN = 3;
    uint8 internal constant ST_CLAIMED = 4;
    uint8 internal constant ST_REBATED = 5;

    // Status bitmask per action: bit n set = status ordinal n qualifies.
    uint256 internal constant MASK_CAN_REGISTER = 0x05; // None (bit 0) or Cancelled (bit 2)
    uint256 internal constant MASK_REGISTERED = 0x02; // Registered (bit 1)
    uint256 internal constant MASK_CHECKED_IN = 0x08; // CheckedIn (bit 3)

    uint256 internal constant DUST_TIMEOUT = 30 days;

    IKodyl internal k;
    uint256[] internal eids;
    uint256[] internal deposits;
    address[] internal actors;
    address internal organizer;

    // Per-event schedule mirror (read once at construction) so phase targeting
    // and warping need no external calls mid-run.
    uint256[] internal deadlineOf;
    uint256[] internal startOf;
    uint256[] internal endOf;
    uint256[] internal disputeOf;

    // Independent ghost accounting (NOT read from the contract), tracked
    // PER EVENT so a cross-event pot leak is caught: every wei that enters via
    // register, every wei that leaves via a payout/refund/dust, attributed to
    // the event it belongs to. Global totals are the sums of these.
    uint256[] public inPer;
    uint256[] public outPer;
    // Forced ETH (selfdestruct / block rewards, modelled with vm.deal): enters
    // the balance without touching the ledger, so it is tracked separately.
    uint256 public ghostForced;

    // Ghost protocol model: per-(event index, actor) expected status and
    // per-event registered / checked-in / claimed counts, advanced only on
    // observed successful calls - never read back from the contract.
    mapping(uint256 => mapping(address => uint8)) public ghostStatus;
    uint256[] public ghostReg;
    uint256[] public ghostChk;
    uint256[] public ghostClm;
    bool[] public ghostEvCancelled;

    // Claim distribution check results, asserted by the parent invariant.
    uint256 public claimMismatchCount;
    uint256 public lastClaimExpected;
    uint256 public lastClaimActual;
    uint256 public rebateMismatchCount;
    uint256 public lastRebateExpected;
    uint256 public lastRebateActual;

    // Per-action attempted / succeeded counters, indexed by Act. Pure
    // visibility ghosts: the invariants assert nothing about them (campaign
    // composition varies), they exist so path starvation is measurable.
    enum Act {
        Register,
        Cancel,
        ClaimRefund,
        CheckIn,
        Claim,
        ClaimDust,
        CancelEvent,
        WarpForward,
        WarpToNextPhase,
        ForceEth,
        ClaimRebate
    }

    uint256[11] public attempted;
    uint256[11] public succeeded;

    constructor(
        IKodyl _k,
        uint256[] memory _eids,
        uint256[] memory _deposits,
        address[] memory _actors,
        address _organizer
    ) {
        k = _k;
        eids = _eids;
        deposits = _deposits;
        actors = _actors;
        organizer = _organizer;
        for (uint256 i = 0; i < _eids.length; ++i) {
            (,, uint256 dl, uint256 st, uint256 en, uint256 dp,) = k.getEvent(_eids[i]);
            deadlineOf.push(dl);
            startOf.push(st);
            endOf.push(en);
            disputeOf.push(dp);
            inPer.push(0);
            outPer.push(0);
            ghostReg.push(0);
            ghostChk.push(0);
            ghostClm.push(0);
            ghostEvCancelled.push(false);
        }
    }

    function ghostIn() public view returns (uint256 s) {
        for (uint256 i = 0; i < inPer.length; ++i) {
            s += inPer[i];
        }
    }

    function ghostOut() public view returns (uint256 s) {
        for (uint256 i = 0; i < outPer.length; ++i) {
            s += outPer[i];
        }
    }

    // --- targeting ---

    // Ghost-side mirror of the contract's derived state ordinals
    // (Registration 0, Active 1, Dispute 2, Settled 3, Cancelled 4).
    function _phase(uint256 i) internal view returns (uint256) {
        if (ghostEvCancelled[i]) return 4;
        uint256 t = vm.getBlockTimestamp();
        if (t < startOf[i]) return 0;
        if (t <= endOf[i]) return 1;
        if (t <= endOf[i] + disputeOf[i]) return 2;
        return 3;
    }

    function _regOpen(uint256 i) internal view returns (bool) {
        return _phase(i) == 0;
    }

    function _cancelOpen(uint256 i) internal view returns (bool) {
        return vm.getBlockTimestamp() <= deadlineOf[i];
    }

    function _checkInOpen(uint256 i) internal view returns (bool) {
        uint256 p = _phase(i);
        return p == 1 || p == 2;
    }

    function _claimOpen(uint256 i) internal view returns (bool) {
        return _phase(i) == 3 && inPer[i] > outPer[i];
    }

    function _refundOpen(uint256 i) internal view returns (bool) {
        return ghostEvCancelled[i];
    }

    function _dustOpen(uint256 i) internal view returns (bool) {
        if (_phase(i) != 3 || inPer[i] <= outPer[i]) return false;
        // The early all-claimed door is shut while a rebate pool exists (no
        // rebated-count on-chain); only the timeout opens the sweep then.
        return (ghostClm[i] == ghostChk[i] && _ghostRebate(i) == 0)
            || vm.getBlockTimestamp() > endOf[i] + disputeOf[i] + DUST_TIMEOUT;
    }

    // The contract's per-no-show rebate from GHOST counts: the forfeitures
    // above the claimants' capped total, split across the no-shows.
    function _ghostRebate(uint256 i) internal view returns (uint256) {
        if (ghostChk[i] == 0 || ghostReg[i] <= ghostChk[i]) return 0;
        uint256 dep = deposits[i];
        uint256 noShow = ghostReg[i] - ghostChk[i];
        uint256 forfeited = noShow * dep;
        uint256 capTotal = ghostChk[i] * dep;
        if (forfeited <= capTotal) return 0;
        return (forfeited - capTotal) / noShow;
    }

    // The first LAZY_CLAIMERS actors never claim through the targeted path:
    // their unclaimed payouts age into the timeout dust sweep, keeping that
    // path fed instead of letting eager claims drain every settled pot. The
    // seed fallback can still pick them, fuzzing claim-after-sweep
    // (PayoutSwept) among the revert paths.
    uint256 internal constant LAZY_CLAIMERS = 2;

    // Scan the actor set (starting at a seed-derived offset) for one whose
    // ghost status matches the mask; report whether one was found.
    function _actorWith(uint256 i, uint256 stMask, uint256 seed) internal view returns (address a, bool found) {
        return _actorWith(i, stMask, seed, 0);
    }

    function _actorWith(uint256 i, uint256 stMask, uint256 seed, uint256 fromIdx)
        internal
        view
        returns (address a, bool found)
    {
        uint256 span = actors.length - fromIdx;
        uint256 off = seed % span;
        for (uint256 j = 0; j < span; ++j) {
            address c = actors[fromIdx + (off + j) % span];
            if (((stMask >> ghostStatus[i][c]) & 1) == 1) return (c, true);
        }
        return (actors[fromIdx + off], false);
    }

    // Scan for an (event, actor) pair where the event passes evOk and the
    // actor's ghost status matches stMask, so the action is likely to succeed.
    // Falls back to a purely seed-derived pick when none qualifies, keeping
    // the revert paths under fuzz.
    function _target(uint256 seed, function(uint256) view returns (bool) evOk, uint256 stMask)
        internal
        view
        returns (uint256 i, address a)
    {
        i = seed % eids.length;
        a = actors[(seed >> 8) % actors.length];
        for (uint256 j = 0; j < eids.length; ++j) {
            uint256 c = (i + j) % eids.length;
            if (!evOk(c)) continue;
            (address cand, bool ok) = _actorWith(c, stMask, seed >> 8);
            if (ok) return (c, cand);
        }
    }

    function _attempt(Act a) internal {
        attempted[uint256(a)]++;
    }

    function _success(Act a) internal {
        succeeded[uint256(a)]++;
    }

    // Credits any contract-balance decrease during the call to THIS event.
    function _out(uint256 i, uint256 before) internal {
        uint256 nowBal = address(k).balance;
        if (before > nowBal) outPer[i] += before - nowBal;
    }

    // --- actions ---

    // Registrations feed every downstream path, and the registration windows
    // only span the early part of a run's timeline, so one action fills one
    // qualifying actor into EACH event still open for registration.
    function register(uint256 seed) public {
        uint256 calls;
        for (uint256 c = 0; c < eids.length; ++c) {
            if (!_regOpen(c)) continue;
            (address a, bool ok) = _actorWith(c, MASK_CAN_REGISTER, seed >> 8);
            if (!ok) continue; // every actor already registered here
            _attempt(Act.Register);
            _tryRegister(c, a);
            calls++;
        }
        if (calls == 0) {
            // Nothing qualifies: raw seed pick keeps the revert path fuzzed.
            _attempt(Act.Register);
            _tryRegister(seed % eids.length, actors[(seed >> 8) % actors.length]);
        }
    }

    function _tryRegister(uint256 i, address a) internal {
        uint256 dep = deposits[i];
        vm.deal(a, dep);
        uint256 before = address(k).balance;
        vm.prank(a);
        try k.register{value: dep}(eids[i]) {
            _success(Act.Register);
            inPer[i] += address(k).balance - before;
            ghostStatus[i][a] = ST_REGISTERED;
            ghostReg[i]++;
        } catch {}
    }

    function cancel(uint256 seed) public {
        _attempt(Act.Cancel);
        (uint256 i, address a) = _target(seed, _cancelOpen, MASK_REGISTERED);
        uint256 before = address(k).balance;
        vm.prank(a);
        try k.cancel(eids[i]) {
            _success(Act.Cancel);
            ghostStatus[i][a] = ST_CANCELLED;
            ghostReg[i]--;
        } catch {}
        _out(i, before);
    }

    function claimRefund(uint256 seed) public {
        _attempt(Act.ClaimRefund);
        (uint256 i, address a) = _target(seed, _refundOpen, MASK_REGISTERED);
        uint256 before = address(k).balance;
        vm.prank(a);
        try k.claimRefund(eids[i]) {
            _success(Act.ClaimRefund);
            ghostStatus[i][a] = ST_CANCELLED;
            ghostReg[i]--;
        } catch {}
        _out(i, before);
    }

    // Same fill-each-open-event shape as register: the check-in windows are a
    // minority of a run's timeline, so use them while they are open.
    function checkIn(uint256 seed) public {
        uint256 calls;
        for (uint256 c = 0; c < eids.length; ++c) {
            if (!_checkInOpen(c)) continue;
            (address a, bool ok) = _actorWith(c, MASK_REGISTERED, seed >> 8);
            if (!ok) continue; // nobody left to check in here
            _attempt(Act.CheckIn);
            vm.prank(organizer);
            try k.checkIn(eids[c], a) {
                _success(Act.CheckIn);
                ghostStatus[c][a] = ST_CHECKED_IN;
                ghostChk[c]++;
            } catch {}
            calls++;
        }
        if (calls == 0) {
            _attempt(Act.CheckIn);
            uint256 i = seed % eids.length;
            address a = actors[(seed >> 8) % actors.length];
            // checkIn silently skips anyone not Registered, so a non-reverting
            // call only counts as a success when the model says a flip happened.
            bool wasRegistered = ghostStatus[i][a] == ST_REGISTERED;
            vm.prank(organizer);
            try k.checkIn(eids[i], a) {
                if (wasRegistered) {
                    _success(Act.CheckIn);
                    ghostStatus[i][a] = ST_CHECKED_IN;
                    ghostChk[i]++;
                }
            } catch {}
        }
    }

    function claim(uint256 seed) public {
        uint256 calls;
        for (uint256 c = 0; c < eids.length; ++c) {
            if (!_claimOpen(c)) continue;
            (address a, bool ok) = _actorWith(c, MASK_CHECKED_IN, seed >> 8, LAZY_CLAIMERS);
            if (!ok) continue; // nobody (willing) with a pending payout here
            _attempt(Act.Claim);
            _tryClaim(c, a);
            calls++;
        }
        if (calls == 0) {
            _attempt(Act.Claim);
            _tryClaim(seed % eids.length, actors[(seed >> 8) % actors.length]);
        }
    }

    function _tryClaim(uint256 i, address a) internal {
        uint256 dep = deposits[i];
        uint256 beforeK = address(k).balance;
        uint256 beforeA = a.balance;
        vm.prank(a);
        try k.claim(eids[i]) {
            _success(Act.Claim);
            ghostStatus[i][a] = ST_CLAIMED;
            ghostClm[i]++;
            // Distribution check: the claimant (a plain EOA, so the delta is
            // exact) must receive deposit + min(floor(noShow * deposit /
            // checkedIn), deposit) - the capped reward - computed from the
            // GHOST counts, not the contract's.
            bool modelOk = ghostChk[i] > 0 && ghostReg[i] >= ghostChk[i];
            uint256 uncapped = modelOk ? ((ghostReg[i] - ghostChk[i]) * dep) / ghostChk[i] : 0;
            uint256 expect = modelOk ? dep + (uncapped > dep ? dep : uncapped) : 0;
            uint256 actual = a.balance - beforeA;
            if (!modelOk || actual != expect) {
                claimMismatchCount++;
                lastClaimExpected = expect;
                lastClaimActual = actual;
            }
        } catch {}
        _out(i, beforeK);
    }

    function claimRebate(uint256 seed) public {
        uint256 calls;
        for (uint256 c = 0; c < eids.length; ++c) {
            if (!_claimOpen(c) || _ghostRebate(c) == 0) continue;
            (address a, bool ok) = _actorWith(c, MASK_REGISTERED, seed >> 8);
            if (!ok) continue; // no still-registered no-show here
            _attempt(Act.ClaimRebate);
            _tryClaimRebate(c, a);
            calls++;
        }
        if (calls == 0) {
            _attempt(Act.ClaimRebate);
            _tryClaimRebate(seed % eids.length, actors[(seed >> 8) % actors.length]);
        }
    }

    function _tryClaimRebate(uint256 i, address a) internal {
        uint256 beforeK = address(k).balance;
        uint256 beforeA = a.balance;
        uint256 expect = _ghostRebate(i);
        vm.prank(a);
        try k.claimNoShowRebate(eids[i]) {
            _success(Act.ClaimRebate);
            ghostStatus[i][a] = ST_REBATED;
            uint256 actual = a.balance - beforeA;
            if (expect == 0 || actual != expect) {
                rebateMismatchCount++;
                lastRebateExpected = expect;
                lastRebateActual = actual;
            }
        } catch {}
        _out(i, beforeK);
    }

    function claimDust(uint256 seed) public {
        _attempt(Act.ClaimDust);
        uint256 i = seed % eids.length;
        for (uint256 j = 0; j < eids.length; ++j) {
            uint256 c = (i + j) % eids.length;
            if (_dustOpen(c)) {
                i = c;
                break;
            }
        }
        uint256 before = address(k).balance;
        try k.claimDust(eids[i]) {
            _success(Act.ClaimDust);
        } catch {}
        _out(i, before);
    }

    function cancelEvent(uint256 seed) public {
        // Rare on purpose: one early success kills the whole settlement
        // pipeline of that event for the rest of the run.
        if (seed % 10 != 0) return;
        _attempt(Act.CancelEvent);
        uint256 i = (seed >> 8) % eids.length;
        vm.prank(organizer);
        try k.cancelEvent(eids[i]) {
            _success(Act.CancelEvent);
            ghostEvCancelled[i] = true;
        } catch {}
    }

    // --- time ---

    // Small random drift; the phase jumps come from warpToNextPhase, so this
    // stays small enough that runs do not blow past every lifecycle window.
    function warpForward(uint256 amount) public {
        _attempt(Act.WarpForward);
        amount = bound(amount, 5 minutes, 12 hours);
        vm.warp(vm.getBlockTimestamp() + amount);
        _success(Act.WarpForward);
    }

    // Warp to just past the NEXT lifecycle boundary (cancellationDeadline /
    // start / end / end + dispute / end + dispute + 30 days) of a seed-chosen
    // event. No-op once all of that event's boundaries are behind us.
    function warpToNextPhase(uint256 seed) public {
        _attempt(Act.WarpToNextPhase);
        uint256 i = seed % eids.length;
        uint256 settle = endOf[i] + disputeOf[i];
        uint256[5] memory bs = [deadlineOf[i], startOf[i], endOf[i], settle, settle + DUST_TIMEOUT];
        for (uint256 j = 0; j < 5; ++j) {
            if (bs[j] >= vm.getBlockTimestamp()) {
                vm.warp(bs[j] + 1);
                _success(Act.WarpToNextPhase);
                return;
            }
        }
    }

    // --- forced ETH ---

    // Value pushed into the contract without a payable path (selfdestruct,
    // block rewards). The ledger cannot see or reject it, so the invariants
    // must tolerate balance exceeding totalHeld by exactly this amount.
    function forceEth(uint96 seed) public {
        _attempt(Act.ForceEth);
        uint256 amt = bound(uint256(seed), 1, 1 ether);
        vm.deal(address(k), address(k).balance + amt);
        ghostForced += amt;
        _success(Act.ForceEth);
    }
}

contract KodylConservationInvariant is Test {
    uint256 internal constant START_TS = 1_700_000_000;

    IKodyl internal k;
    LifecycleHandler internal handler;
    uint256[] internal eids;
    uint256[] internal deposits;
    address internal maintainer = makeAddr("maintainer");

    function setUp() public {
        vm.warp(START_TS);
        k = IKodyl(payable(CoreDeploy.deploy("Kodyl", abi.encode(maintainer))));

        deposits = new uint256[](3);
        deposits[0] = 1 ether;
        deposits[1] = 333 wei; // indivisible, stresses reward/dust rounding
        deposits[2] = 5 ether;
        // Staggered, overlapping schedules so different phases coexist during
        // a run: while event 0 is in Dispute, event 1 is Active and event 2 is
        // still open for registration.
        uint256[3] memory deadlines = [uint256(START_TS + 1 days), START_TS + 2 days, START_TS + 3 days];
        uint256[3] memory starts = [uint256(START_TS + 5 days), START_TS + 9 days, START_TS + 13 days];
        uint256[3] memory ends = [uint256(START_TS + 10 days), START_TS + 15 days, START_TS + 20 days];
        uint256[3] memory disputes = [uint256(2 days), 2 days, 3 days];
        eids = new uint256[](3);
        address organizer = makeAddr("organizer");
        for (uint256 i = 0; i < 3; ++i) {
            vm.prank(organizer);
            eids[i] = k.createEvent(deposits[i], deadlines[i], starts[i], ends[i], disputes[i], 0, "ipfs://meta");
        }

        address[] memory actors = new address[](8);
        for (uint256 i = 0; i < 8; ++i) {
            actors[i] = makeAddr(string.concat("actor", vm.toString(i)));
        }

        handler = new LifecycleHandler(k, eids, deposits, actors, organizer);
        // Restrict the fuzz surface to the handler; its internal vm.prank calls
        // fix msg.sender, so only handler actions move funds.
        targetContract(address(handler));
    }

    /// The three-way ledger equality. If any path moved the contract balance,
    /// totalHeld, and the per-event pots out of lockstep - the failure mode of
    /// a shared-custody accounting bug - one of these breaks. Forced ETH sits
    /// outside the ledger by design, so the balance side allows exactly it.
    function invariant_ledgerThreeWayEquality() public view {
        uint256 sumHeld;
        for (uint256 i = 0; i < eids.length; ++i) {
            sumHeld += k.held(eids[i]);
        }
        assertEq(sumHeld, k.totalHeld(), "sum(held) != totalHeld");
        assertEq(address(k).balance, k.totalHeld() + handler.ghostForced(), "balance != totalHeld + forced");
    }

    /// Compiler-independent conservation: every wei that entered the contract
    /// (deposits and forced ETH alike) is still there or has left through an
    /// accounted withdrawal. Tracked by the handler from balance deltas, never
    /// read from the contract's ledger, so it cross-checks the ledger rather
    /// than restating it.
    function invariant_ethConserved() public view {
        // in + forced - out == what remains in the contract.
        assertEq(handler.ghostIn() + handler.ghostForced() - handler.ghostOut(), address(k).balance, "ETH conservation broken");
    }

    /// Per-event conservation: each event's on-chain pot equals exactly what was
    /// deposited into it minus what was paid out of it, tracked independently
    /// per event. This is the check that catches a cross-event pot leak - one
    /// event's claim/dust touching another's funds - which the aggregate
    /// equalities above cannot see. Ledger-only: forced ETH never enters a pot.
    function invariant_perEventConserved() public view {
        for (uint256 i = 0; i < eids.length; ++i) {
            assertEq(k.held(eids[i]), handler.inPer(i) - handler.outPer(i), "per-event pot drift");
        }
    }

    /// Distribution sensitivity: the wei-conservation invariants above cannot
    /// see a mis-SIZED payout (right total, wrong split). The handler compares
    /// every successful claim's balance delta against its ghost model's
    /// deposit + floor(noShow * deposit / checkedIn) and records mismatches;
    /// this asserts none happened.
    function invariant_claimPayoutsExact() public view {
        assertEq(handler.claimMismatchCount(), 0, "claim payout != ghost-model payout");
    }

    /// Same discipline for the reward cap's no-show rebate: every successful
    /// claimNoShowRebate must pay exactly the ghost-model per-no-show excess.
    function invariant_rebatePayoutsExact() public view {
        assertEq(handler.rebateMismatchCount(), 0, "rebate payout != ghost-model rebate");
    }

    /// Not an assertion - campaign composition varies, so nothing is required
    /// of these counts. Logged (visible with -vv) so path starvation stays
    /// measurable. Foundry restores the setUp snapshot between runs, so these
    /// are the counts of the campaign's final run of `depth` calls.
    function afterInvariant() public view {
        string[11] memory names = [
            "register",
            "cancel",
            "claimRefund",
            "checkIn",
            "claim",
            "claimDust",
            "cancelEvent",
            "warpForward",
            "warpToNextPhase",
            "forceEth",
            "claimRebate"
        ];
        for (uint256 i = 0; i < names.length; ++i) {
            console2.log(string.concat(names[i], " attempted/succeeded:"), handler.attempted(i), handler.succeeded(i));
        }
    }
}
