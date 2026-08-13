// SPDX-License-Identifier: MIT
pragma solidity ^0.8.33;

import {Test} from "forge-std/Test.sol";
import {CoreDeploy} from "./CoreDeploy.sol";
import {IKodyl} from "./Kodyl.t.sol";

/// @notice Reenters Kodyl on receiving ETH, trying to extract more than its
///         fair share by re-invoking fund-moving functions during the payout.
contract ReentrantAttacker {
    IKodyl internal k;
    uint256 internal eid;
    uint8 internal mode; // 0 none, 1 double-claim, 2 claimDust, 3 cross-event cancel
    uint256 internal crossEid;
    uint256 public reenters;

    constructor(IKodyl _k) {
        k = _k;
    }

    function arm(uint256 _eid, uint8 _mode, uint256 _cross) external {
        eid = _eid;
        mode = _mode;
        crossEid = _cross;
    }

    function register(uint256 e) external payable {
        k.register{value: msg.value}(e);
    }

    function claim() external {
        k.claim(eid);
    }

    receive() external payable {
        if (reenters > 0) return; // reenter once
        reenters++;
        if (mode == 1) {
            try k.claim(eid) {} catch {}
        } else if (mode == 2) {
            try k.claimDust(eid) {} catch {}
        } else if (mode == 3) {
            try k.cancel(crossEid) {} catch {}
        }
    }
}

contract KodylAccountingTest is Test {
    uint256 internal constant START_TS = 1_700_000_000;

    address internal maintainer = makeAddr("maintainer");
    address internal organizer = makeAddr("organizer");

    IKodyl internal k;
    uint256 internal eventStart;
    uint256 internal eventEnd;
    uint256 internal disputePeriod = 1 days;

    function setUp() public {
        vm.warp(START_TS);
        k = IKodyl(payable(CoreDeploy.deploy("Kodyl", abi.encode(maintainer))));
        eventStart = START_TS + 30 days;
        eventEnd = eventStart + 1 days;
    }

    function _create(uint256 deposit) internal returns (uint256) {
        vm.prank(organizer);
        return k.createEvent(deposit, eventStart - 7 days, eventStart, eventEnd, disputePeriod, 0, "ipfs://meta");
    }

    // Balance/ledger consistency the contract must always satisfy.
    function _assertConsistent(uint256[] memory eids) internal view {
        uint256 sumHeld;
        for (uint256 i = 0; i < eids.length; ++i) {
            sumHeld += k.held(eids[i]);
        }
        assertEq(sumHeld, k.totalHeld(), "sum(held) != totalHeld");
        assertEq(address(k).balance, k.totalHeld(), "balance != totalHeld");
    }

    // ==================================================================
    // Reentrancy: a malicious claimant cannot extract more than owed.
    // ==================================================================

    function _runReentrancy(uint8 mode) internal returns (uint256 payout, ReentrantAttacker atk) {
        uint256 dep = 1 ether;
        uint256 eid = _create(dep);
        atk = new ReentrantAttacker(k);
        address honest = makeAddr("honest");
        address noshow = makeAddr("noshow");

        vm.deal(address(atk), dep);
        atk.register{value: dep}(eid);
        vm.deal(honest, dep);
        vm.prank(honest);
        k.register{value: dep}(eid);
        vm.deal(noshow, dep);
        vm.prank(noshow);
        k.register{value: dep}(eid);

        vm.warp(eventStart);
        vm.startPrank(organizer);
        k.checkIn(eid, address(atk));
        k.checkIn(eid, honest);
        vm.stopPrank();

        // honest claims first so the attacker is the LAST claimant (enables the
        // claimDust reentrancy path: clmCount == chkCount right after its claim).
        vm.warp(eventEnd + disputePeriod + 1);
        vm.prank(honest);
        k.claim(eid);

        atk.arm(eid, mode, 0);
        uint256 before = address(atk).balance;
        atk.claim();
        payout = address(atk).balance - before;

        uint256[] memory eids = new uint256[](1);
        eids[0] = eid;
        _assertConsistent(eids);
    }

    function test_reentrancy_doubleClaimGainsNothing() public {
        // 3 registered, 2 checked in, 1 no-show: reward = 1 ETH / 2 = 0.5.
        (uint256 payout, ReentrantAttacker atk) = _runReentrancy(1);
        assertEq(atk.reenters(), 1, "did not reenter");
        assertEq(payout, 1.5 ether, "attacker got more than deposit+reward");
    }

    function test_reentrancy_claimDustGainsNothing() public {
        (uint256 payout,) = _runReentrancy(2);
        // No dust here (1 ETH / 2 divides evenly), so reentrant claimDust reverts;
        // attacker still gets exactly its payout and nothing extra reaches it.
        assertEq(payout, 1.5 ether);
        // Dust pot is zero; maintainer got nothing.
        assertEq(maintainer.balance, 0);
    }

    function test_reentrancy_crossEventCancelStaysConsistent() public {
        // Attacker is also registered in a second event; reenters to cancel it
        // mid-payout. Must remain fully accounted.
        uint256 dep = 1 ether;
        uint256 a = _create(dep);
        vm.warp(START_TS + 1);
        uint256 b = _create(dep);

        ReentrantAttacker atk = new ReentrantAttacker(k);
        address honest = makeAddr("honest2");
        address noshow = makeAddr("noshow2");
        vm.deal(address(atk), 2 * dep);
        atk.register{value: dep}(a);
        atk.register{value: dep}(b); // registered in b too
        vm.deal(honest, dep);
        vm.prank(honest);
        k.register{value: dep}(a);
        vm.deal(noshow, dep);
        vm.prank(noshow);
        k.register{value: dep}(a);

        vm.warp(eventStart);
        vm.startPrank(organizer);
        k.checkIn(a, address(atk));
        k.checkIn(a, honest);
        vm.stopPrank();

        vm.warp(eventEnd + disputePeriod + 1); // event a settled; b's deadline long past
        // b is still in Registration only if its deadline hasn't passed; here it
        // has, so the reentrant cancel(b) will revert - either way, consistent.
        atk.arm(a, 3, b);
        uint256 before = address(atk).balance;
        atk.claim();
        uint256 payout = address(atk).balance - before;

        assertEq(payout, 1.5 ether, "unexpected payout");
        uint256[] memory eids = new uint256[](2);
        eids[0] = a;
        eids[1] = b;
        _assertConsistent(eids);
    }

    // ==================================================================
    // Reward/dust arithmetic at indivisible amounts: exact per-event
    // conservation (deposited in == paid out + dust), no wei created/lost.
    // ==================================================================

    function _conservationRun(uint256 dep, uint256 nRegistered, uint256 nCheckedIn) internal {
        assertLe(nCheckedIn, nRegistered);
        uint256 eid = _create(dep);

        address[] memory who = new address[](nRegistered);
        for (uint256 i = 0; i < nRegistered; ++i) {
            who[i] = makeAddr(string.concat("acct", vm.toString(i), "_", vm.toString(dep)));
            vm.deal(who[i], dep);
            vm.prank(who[i]);
            k.register{value: dep}(eid);
        }

        vm.warp(eventStart);
        for (uint256 i = 0; i < nCheckedIn; ++i) {
            vm.prank(organizer);
            k.checkIn(eid, who[i]);
        }

        vm.warp(eventEnd + disputePeriod + 1);

        if (nCheckedIn == 0) {
            // Zero check-ins is abandonment: no dust path ever (even past the
            // sweep timeout), the pot refunds in full and never expires.
            vm.expectRevert(IKodyl.DustNotClaimable.selector);
            k.claimDust(eid);
            vm.warp(eventEnd + disputePeriod + 30 days + 1);
            vm.expectRevert(IKodyl.DustNotClaimable.selector);
            k.claimDust(eid);
            uint256 refunded;
            for (uint256 i = 0; i < nRegistered; ++i) {
                vm.prank(who[i]);
                k.claimRefund(eid);
                assertEq(who[i].balance, dep, "full refund");
                refunded += dep;
            }
            assertEq(refunded, dep * nRegistered, "abandonment refunds conserve");
            assertEq(k.held(eid), 0);
            assertEq(maintainer.balance, 0, "maintainer gets nothing from abandonment");
            return;
        }

        _settleChecked(eid, dep, nRegistered, nCheckedIn, who);
    }

    // Settlement half of _conservationRun for the checked-in regime, split
    // out to keep both functions under the compiler's stack budget.
    function _settleChecked(uint256 eid, uint256 dep, uint256 nReg, uint256 nChk, address[] memory who) internal {
        uint256 paidOut;
        for (uint256 i = 0; i < nChk; ++i) {
            vm.prank(who[i]);
            k.claim(eid);
            paidOut += who[i].balance;
        }

        // The reward cap's rebate leg: with cap multiple 1 the cap binds
        // exactly when no-shows outnumber claimants (reward is then one
        // deposit), and each no-show pulls its floor share of the excess -
        // which can be zero at tiny deposits, leaving the excess as dust.
        uint256 noShow = nReg - nChk;
        uint256 fairReward = noShow > nChk ? dep : (noShow * dep) / nChk;
        uint256 rebatePer = noShow > nChk ? ((noShow - nChk) * dep) / noShow : 0;
        uint256 rebatesPaid;
        for (uint256 i = nChk; i < nReg && rebatePer > 0; ++i) {
            vm.prank(who[i]);
            k.claimNoShowRebate(eid);
            assertEq(who[i].balance, rebatePer, "per-no-show rebate");
            rebatesPaid += rebatePer;
        }

        uint256 dust = k.held(eid);
        if (dust > 0) {
            // With a rebate pool the early all-claimed door is shut; the
            // remainder is sweepable only after the timeout.
            if (rebatePer > 0) vm.warp(eventEnd + disputePeriod + 30 days + 1);
            k.claimDust(eid);
            assertEq(maintainer.balance, dust, "dust payout mismatch");
        }

        // The core property: every wei deposited left as a payout, a rebate,
        // or dust - and no claimant got more than deposit + the capped reward.
        assertEq(paidOut + rebatesPaid + dust, dep * nReg, "ETH not conserved for event");
        assertEq(k.held(eid), 0);
        assertEq(paidOut, nChk * (dep + fairReward), "reward math drift");
        if (noShow > nChk) {
            assertEq(dust, (noShow - nChk) * dep - noShow * rebatePer, "dust != rebate remainder");
        } else {
            assertEq(dust, (noShow * dep) % nChk, "dust != remainder");
        }
    }

    function test_conservation_indivisible7wei() public {
        _conservationRun(7 wei, 4, 3); // reward floor(7/3)=2, dust 1
    }

    function test_conservation_oneCheckinManyNoShows() public {
        _conservationRun(1 ether, 5, 1); // one claimant sweeps 4 ETH of forfeits
    }

    function test_conservation_primeSplit() public {
        _conservationRun(100 wei, 7, 3); // floor(400/3)=133, dust 400%3=1
    }

    function test_conservation_allCheckedIn() public {
        _conservationRun(1 ether, 4, 4); // no no-shows: reward 0, dust 0
    }

    function test_conservation_zeroCheckins() public {
        _conservationRun(1 ether, 3, 0); // everything to dust
    }

    function test_conservation_singleAttendee() public {
        _conservationRun(1 ether, 1, 1); // trivial: gets own deposit back, no dust
    }

    // ==================================================================
    // Known deviation: after the timeout sweep, a late claim cannot pay out
    // (the pot is gone). It must fail safely, never create ETH.
    // ==================================================================

    function test_lateClaimAfterDustSweep_failsSafely() public {
        uint256 dep = 1 ether;
        uint256 eid = _create(dep);
        address alice = makeAddr("alice");
        address bob = makeAddr("bob");
        vm.deal(alice, dep);
        vm.prank(alice);
        k.register{value: dep}(eid);
        vm.deal(bob, dep);
        vm.prank(bob);
        k.register{value: dep}(eid);

        vm.warp(eventStart);
        vm.startPrank(organizer);
        k.checkIn(eid, alice);
        k.checkIn(eid, bob);
        vm.stopPrank();

        // Neither claims; after the timeout the whole pot sweeps to maintainer.
        vm.warp(eventEnd + disputePeriod + 30 days + 1);
        uint256 mBefore = maintainer.balance;
        k.claimDust(eid);
        assertEq(maintainer.balance - mBefore, 2 * dep);
        assertEq(k.totalHeld(), 0);
        assertEq(address(k).balance, 0);

        // A late claim now has no funds behind it and must revert with a clear
        // named error (not an opaque panic, and no ETH conjured).
        vm.prank(alice);
        vm.expectRevert(IKodyl.PayoutSwept.selector);
        k.claim(eid);
        assertEq(address(k).balance, 0);
    }
}
