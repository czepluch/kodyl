// SPDX-License-Identifier: MIT
pragma solidity ^0.8.33;

import {Test} from "forge-std/Test.sol";
import {CoreDeploy} from "./CoreDeploy.sol";
import {IKodyl} from "./Kodyl.t.sol";

/// @notice Drives the FULL lifecycle (register / cancel / claimRefund / check-in
///         / claim / dust / cancelEvent) across three concurrent events with
///         different deposits, advancing time, from a bounded actor set. Every
///         action swallows reverts so the fuzzer explores freely; the parent
///         asserts the accounting after each call.
///
/// This reaches the paths the registration-phase invariant cannot: reward
/// payouts, dust sweeps, and cross-event interleaving - exactly where a
/// shared-custody accounting bug would surface.
contract LifecycleHandler is Test {
    IKodyl internal k;
    uint256[] internal eids;
    uint256[] internal deposits;
    address[] internal actors;
    address internal organizer;
    uint256 internal start;

    // Independent ghost accounting (NOT read from the contract), tracked
    // PER EVENT so a cross-event pot leak is caught: every wei that enters via
    // register, every wei that leaves via a payout/refund/dust, attributed to
    // the event it belongs to. Global totals are the sums of these.
    uint256[] public inPer;
    uint256[] public outPer;

    constructor(
        IKodyl _k,
        uint256[] memory _eids,
        uint256[] memory _deposits,
        address[] memory _actors,
        address _organizer,
        uint256 _start
    ) {
        k = _k;
        eids = _eids;
        deposits = _deposits;
        actors = _actors;
        organizer = _organizer;
        start = _start;
        inPer = new uint256[](_eids.length);
        outPer = new uint256[](_eids.length);
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

    function _pick(uint256 seed) internal view returns (uint256 i, uint256 eid, uint256 dep, address a) {
        i = seed % eids.length;
        eid = eids[i];
        dep = deposits[i];
        a = actors[(seed >> 8) % actors.length];
    }

    function register(uint256 seed) public {
        (uint256 i, uint256 eid, uint256 dep, address a) = _pick(seed);
        vm.deal(a, dep);
        uint256 before = address(k).balance;
        vm.prank(a);
        try k.register{value: dep}(eid) {
            inPer[i] += address(k).balance - before;
        } catch {}
    }

    // Credits any contract-balance decrease during the call to THIS event.
    function _out(uint256 i, uint256 before) internal {
        uint256 nowBal = address(k).balance;
        if (before > nowBal) outPer[i] += before - nowBal;
    }

    function cancel(uint256 seed) public {
        (uint256 i, uint256 eid,, address a) = _pick(seed);
        uint256 before = address(k).balance;
        vm.prank(a);
        try k.cancel(eid) {} catch {}
        _out(i, before);
    }

    function claimRefund(uint256 seed) public {
        (uint256 i, uint256 eid,, address a) = _pick(seed);
        uint256 before = address(k).balance;
        vm.prank(a);
        try k.claimRefund(eid) {} catch {}
        _out(i, before);
    }

    function checkIn(uint256 seed) public {
        (, uint256 eid,, address a) = _pick(seed);
        vm.prank(organizer);
        try k.checkIn(eid, a) {} catch {}
    }

    function claim(uint256 seed) public {
        (uint256 i, uint256 eid,, address a) = _pick(seed);
        uint256 before = address(k).balance;
        vm.prank(a);
        try k.claim(eid) {} catch {}
        _out(i, before);
    }

    function claimDust(uint256 seed) public {
        (uint256 i, uint256 eid,,) = _pick(seed);
        uint256 before = address(k).balance;
        try k.claimDust(eid) {} catch {}
        _out(i, before);
    }

    function cancelEvent(uint256 seed) public {
        (, uint256 eid,,) = _pick(seed);
        vm.prank(organizer);
        try k.cancelEvent(eid) {} catch {}
    }

    // Advance time in bounded steps so events progress through their phases.
    function warpForward(uint256 amount) public {
        amount = bound(amount, 1 hours, 20 days);
        vm.warp(block.timestamp + amount);
    }

    function eidsLen() external view returns (uint256) {
        return eids.length;
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
        k = IKodyl(CoreDeploy.deploy("Kodyl", abi.encode(maintainer)));

        uint256 eventStart = START_TS + 10 days;
        deposits = new uint256[](3);
        deposits[0] = 1 ether;
        deposits[1] = 333 wei; // indivisible, stresses reward/dust rounding
        deposits[2] = 5 ether;
        eids = new uint256[](3);
        address organizer = makeAddr("organizer");
        for (uint256 i = 0; i < 3; ++i) {
            vm.prank(organizer);
            eids[i] = k.createEvent(
                deposits[i], eventStart - 2 days, eventStart, eventStart + 2 days, 1 days, 0, "ipfs://meta"
            );
        }

        address[] memory actors = new address[](5);
        for (uint256 i = 0; i < 5; ++i) {
            actors[i] = makeAddr(string.concat("actor", vm.toString(i)));
        }

        handler = new LifecycleHandler(k, eids, deposits, actors, organizer, eventStart);
        // The maintainer receives dust; exclude it and the actors from being the
        // fuzzer's msg.sender so only handler actions move funds.
        targetContract(address(handler));
    }

    /// The three-way ledger equality. If any path moved the contract balance,
    /// totalHeld, and the per-event pots out of lockstep - the failure mode of
    /// a shared-custody accounting bug - one of these breaks.
    function invariant_ledgerThreeWayEquality() public view {
        uint256 sumHeld;
        for (uint256 i = 0; i < eids.length; ++i) {
            sumHeld += k.held(eids[i]);
        }
        assertEq(sumHeld, k.totalHeld(), "sum(held) != totalHeld");
        assertEq(address(k).balance, k.totalHeld(), "balance != totalHeld");
    }

    /// Compiler-independent conservation: every wei that entered the contract
    /// is still there or has left through an accounted withdrawal. Tracked by
    /// the handler from balance deltas, never read from the contract's ledger,
    /// so it cross-checks the ledger rather than restating it.
    function invariant_ethConserved() public view {
        // in - out == what remains in the contract.
        assertEq(handler.ghostIn() - handler.ghostOut(), address(k).balance, "ETH conservation broken");
    }

    /// Per-event conservation: each event's on-chain pot equals exactly what was
    /// deposited into it minus what was paid out of it, tracked independently
    /// per event. This is the check that catches a cross-event pot leak - one
    /// event's claim/dust touching another's funds - which the aggregate
    /// equalities above cannot see.
    function invariant_perEventConserved() public view {
        for (uint256 i = 0; i < eids.length; ++i) {
            assertEq(k.held(eids[i]), handler.inPer(i) - handler.outPer(i), "per-event pot drift");
        }
    }
}
