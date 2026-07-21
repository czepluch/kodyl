// SPDX-License-Identifier: MIT
pragma solidity ^0.8.33;

import {Test} from "forge-std/Test.sol";
import {KodylEvent} from "../../src/KodylEvent.sol";
import {IKodylEvent} from "../../src/interfaces/IKodylEvent.sol";

/// @notice Minimal factory stub: KodylEvent only calls `maintainer()` on it.
contract MockFactory {
    address public maintainer;

    constructor(address _maintainer) {
        maintainer = _maintainer;
    }
}

/// @notice Unit tests for KodylEvent, deployed directly to control timestamps
/// (the factory's parameter validation is exercised separately).
contract KodylEventTest is Test {
    KodylEvent internal e;
    MockFactory internal factory;

    address internal organizer = makeAddr("organizer");
    address internal maintainer = makeAddr("maintainer");
    address internal alice = makeAddr("alice");
    address internal bob = makeAddr("bob");
    address internal carol = makeAddr("carol");

    uint256 internal constant DEPOSIT = 1 ether;
    uint256 internal constant START_TS = 1_700_000_000;

    uint256 internal eventStart;
    uint256 internal eventEnd;
    uint256 internal cancellationDeadline;
    uint256 internal disputePeriod = 1 days;

    // Re-declared here so tests can `expectEmit` against them.
    event Registered(address indexed attendee);
    event RegistrationCancelled(address indexed attendee);
    event CheckedIn(address indexed attendee);
    event Claimed(address indexed attendee, uint256 amount);
    event EventCancelled();
    event MetadataUpdated(string newURI);
    event DustClaimed(address indexed recipient, uint256 amount);
    event RefundClaimed(address indexed attendee, uint256 amount);

    function setUp() public {
        vm.warp(START_TS);
        factory = new MockFactory(maintainer);

        eventStart = START_TS + 30 days;
        eventEnd = eventStart + 1 days;
        // Spec intent: deadline well before the event.
        cancellationDeadline = eventStart - 7 days;

        e = _deploy(0); // unlimited capacity
    }

    function _deploy(uint256 maxAttendees) internal returns (KodylEvent) {
        return new KodylEvent(
            address(factory),
            organizer,
            DEPOSIT,
            cancellationDeadline,
            eventStart,
            eventEnd,
            disputePeriod,
            maxAttendees,
            "ipfs://meta"
        );
    }

    function _register(address who) internal {
        vm.deal(who, DEPOSIT);
        vm.prank(who);
        e.register{value: DEPOSIT}();
    }

    // ---- Time helpers ----
    function _toActive() internal {
        vm.warp(eventStart);
    }

    function _toDispute() internal {
        vm.warp(eventEnd + 1);
    }

    function _toSettled() internal {
        vm.warp(eventEnd + disputePeriod + 1);
    }

    // ======================================================================
    // Constructor / state
    // ======================================================================

    function test_constructor_setsParameters() public view {
        assertEq(e.factory(), address(factory));
        assertEq(e.organizer(), organizer);
        assertEq(e.depositAmount(), DEPOSIT);
        assertEq(e.cancellationDeadline(), cancellationDeadline);
        assertEq(e.eventStart(), eventStart);
        assertEq(e.eventEnd(), eventEnd);
        assertEq(e.disputePeriod(), disputePeriod);
        assertEq(e.maxAttendees(), 0);
        assertEq(e.metadataURI(), "ipfs://meta");
        assertEq(e.cancelled(), false);
    }

    function test_getState_transitionsOverTime() public {
        assertEq(uint256(e.getState()), uint256(IKodylEvent.State.Registration));
        _toActive();
        assertEq(uint256(e.getState()), uint256(IKodylEvent.State.Active));
        vm.warp(eventEnd);
        assertEq(uint256(e.getState()), uint256(IKodylEvent.State.Active)); // inclusive
        _toDispute();
        assertEq(uint256(e.getState()), uint256(IKodylEvent.State.Dispute));
        vm.warp(eventEnd + disputePeriod);
        assertEq(uint256(e.getState()), uint256(IKodylEvent.State.Dispute)); // inclusive
        _toSettled();
        assertEq(uint256(e.getState()), uint256(IKodylEvent.State.Settled));
    }

    function test_getState_cancelledOverridesTime() public {
        vm.prank(organizer);
        e.cancelEvent();
        assertEq(uint256(e.getState()), uint256(IKodylEvent.State.Cancelled));
        _toSettled();
        assertEq(uint256(e.getState()), uint256(IKodylEvent.State.Cancelled));
    }

    // ======================================================================
    // register
    // ======================================================================

    function test_register_happyPath() public {
        vm.deal(alice, DEPOSIT);
        vm.expectEmit(true, false, false, false);
        emit Registered(alice);
        vm.prank(alice);
        e.register{value: DEPOSIT}();

        assertEq(uint256(e.attendees(alice)), uint256(IKodylEvent.AttendeeStatus.Registered));
        assertEq(e.registeredCount(), 1);
        assertEq(address(e).balance, DEPOSIT);
    }

    function test_register_revertsOnWrongDeposit() public {
        vm.deal(alice, 2 ether);
        vm.prank(alice);
        vm.expectRevert(abi.encodeWithSelector(IKodylEvent.IncorrectDeposit.selector, DEPOSIT, 0.5 ether));
        e.register{value: 0.5 ether}();
    }

    function test_register_revertsWhenAlreadyRegistered() public {
        _register(alice);
        vm.deal(alice, DEPOSIT);
        vm.prank(alice);
        vm.expectRevert(IKodylEvent.AlreadyRegistered.selector);
        e.register{value: DEPOSIT}();
    }

    function test_register_revertsAfterRegistrationCloses() public {
        _toActive();
        vm.deal(alice, DEPOSIT);
        vm.prank(alice);
        vm.expectRevert(IKodylEvent.RegistrationClosed.selector);
        e.register{value: DEPOSIT}();
    }

    function test_register_revertsWhenFull() public {
        KodylEvent capped = _deploy(1);
        vm.deal(alice, DEPOSIT);
        vm.prank(alice);
        capped.register{value: DEPOSIT}();

        vm.deal(bob, DEPOSIT);
        vm.prank(bob);
        vm.expectRevert(IKodylEvent.EventFull.selector);
        capped.register{value: DEPOSIT}();
    }

    function test_register_reRegisterAfterCancel() public {
        _register(alice);
        vm.prank(alice);
        e.cancel();
        assertEq(uint256(e.attendees(alice)), uint256(IKodylEvent.AttendeeStatus.Cancelled));
        assertEq(e.registeredCount(), 0);

        _register(alice);
        assertEq(uint256(e.attendees(alice)), uint256(IKodylEvent.AttendeeStatus.Registered));
        assertEq(e.registeredCount(), 1);
    }

    // ======================================================================
    // cancel
    // ======================================================================

    function test_cancel_refundsDeposit() public {
        _register(alice);
        uint256 balBefore = alice.balance;
        vm.expectEmit(true, false, false, false);
        emit RegistrationCancelled(alice);
        vm.prank(alice);
        e.cancel();
        assertEq(alice.balance, balBefore + DEPOSIT);
        assertEq(e.registeredCount(), 0);
        assertEq(address(e).balance, 0);
    }

    function test_cancel_revertsAfterDeadline() public {
        _register(alice);
        vm.warp(cancellationDeadline + 1);
        vm.prank(alice);
        vm.expectRevert(IKodylEvent.CancellationDeadlinePassed.selector);
        e.cancel();
    }

    function test_cancel_revertsWhenNotRegistered() public {
        vm.prank(alice);
        vm.expectRevert(
            abi.encodeWithSelector(
                IKodylEvent.InvalidAttendeeStatus.selector,
                IKodylEvent.AttendeeStatus.None,
                IKodylEvent.AttendeeStatus.Registered
            )
        );
        e.cancel();
    }

    // ======================================================================
    // checkIn / checkInBatch
    // ======================================================================

    function test_checkIn_happyPath() public {
        _register(alice);
        _toActive();
        vm.expectEmit(true, false, false, false);
        emit CheckedIn(alice);
        vm.prank(organizer);
        e.checkIn(alice);
        assertEq(uint256(e.attendees(alice)), uint256(IKodylEvent.AttendeeStatus.CheckedIn));
        assertEq(e.checkedInCount(), 1);
    }

    function test_checkIn_revertsWhenNotOrganizer() public {
        _register(alice);
        _toActive();
        vm.prank(alice);
        vm.expectRevert(IKodylEvent.NotOrganizer.selector);
        e.checkIn(alice);
    }

    function test_checkIn_revertsOutsideWindow() public {
        _register(alice);
        // still in Registration, before eventStart
        vm.prank(organizer);
        vm.expectRevert(IKodylEvent.CheckInWindowClosed.selector);
        e.checkIn(alice);
    }

    function test_checkIn_skipsNonRegisteredWithoutRevert() public {
        _toActive();
        // bob never registered; should silently no-op
        vm.prank(organizer);
        e.checkIn(bob);
        assertEq(uint256(e.attendees(bob)), uint256(IKodylEvent.AttendeeStatus.None));
        assertEq(e.checkedInCount(), 0);
    }

    function test_checkInBatch_checksInValidSkipsInvalid() public {
        _register(alice);
        _register(bob);
        _toActive();

        address[] memory batch = new address[](3);
        batch[0] = alice;
        batch[1] = carol; // not registered -> skipped
        batch[2] = bob;

        vm.prank(organizer);
        e.checkInBatch(batch);

        assertEq(uint256(e.attendees(alice)), uint256(IKodylEvent.AttendeeStatus.CheckedIn));
        assertEq(uint256(e.attendees(bob)), uint256(IKodylEvent.AttendeeStatus.CheckedIn));
        assertEq(uint256(e.attendees(carol)), uint256(IKodylEvent.AttendeeStatus.None));
        assertEq(e.checkedInCount(), 2);
    }

    function test_checkInBatch_revertsWhenTooLarge() public {
        _toActive();
        address[] memory batch = new address[](101);
        vm.prank(organizer);
        vm.expectRevert(abi.encodeWithSelector(IKodylEvent.BatchTooLarge.selector, 101, 100));
        e.checkInBatch(batch);
    }

    // ======================================================================
    // claim + reward math
    // ======================================================================

    function test_claim_paysDepositPlusReward() public {
        // 3 register, 2 check in, 1 no-show => forfeited 1 ETH split across 2.
        _register(alice);
        _register(bob);
        _register(carol);
        _toActive();
        vm.startPrank(organizer);
        e.checkIn(alice);
        e.checkIn(bob);
        vm.stopPrank();

        assertEq(e.rewardPerAttendee(), 0.5 ether); // 1 ETH / 2

        _toSettled();
        uint256 balBefore = alice.balance;
        vm.expectEmit(true, false, false, true);
        emit Claimed(alice, DEPOSIT + 0.5 ether);
        vm.prank(alice);
        e.claim();
        assertEq(alice.balance, balBefore + DEPOSIT + 0.5 ether);
        assertEq(uint256(e.attendees(alice)), uint256(IKodylEvent.AttendeeStatus.Claimed));
        assertEq(e.claimedCount(), 1);
    }

    function test_claim_revertsBeforeSettled() public {
        _register(alice);
        _toActive();
        vm.prank(organizer);
        e.checkIn(alice);
        // still in Dispute
        _toDispute();
        vm.prank(alice);
        vm.expectRevert(IKodylEvent.NotSettled.selector);
        e.claim();
    }

    function test_claim_revertsWhenNotCheckedIn() public {
        _register(alice);
        _toSettled();
        vm.prank(alice);
        vm.expectRevert(
            abi.encodeWithSelector(
                IKodylEvent.InvalidAttendeeStatus.selector,
                IKodylEvent.AttendeeStatus.Registered,
                IKodylEvent.AttendeeStatus.CheckedIn
            )
        );
        e.claim();
    }

    // ======================================================================
    // claimDust
    // ======================================================================

    function test_claimDust_afterAllClaimed() public {
        // 3 registered, 2 checked in. 1 ETH forfeited / 2 = 0.5 each, no remainder.
        // Use amounts that produce dust instead: 3 checked in, reward = 1/3.
        _register(alice);
        _register(bob);
        _register(carol);
        address dave = makeAddr("dave");
        vm.deal(dave, DEPOSIT);
        vm.prank(dave);
        e.register{value: DEPOSIT}();

        _toActive();
        vm.startPrank(organizer);
        e.checkIn(alice);
        e.checkIn(bob);
        e.checkIn(carol);
        vm.stopPrank();
        // 1 no-show (dave), forfeited 1 ETH / 3 checked-in = 0.333.., dust = 1 wei
        _toSettled();

        vm.prank(alice);
        e.claim();
        vm.prank(bob);
        e.claim();
        vm.prank(carol);
        e.claim();

        uint256 dust = address(e).balance;
        assertEq(dust, 1 ether % 3); // 1 wei
        uint256 mBefore = maintainer.balance;
        vm.expectEmit(true, false, false, true);
        emit DustClaimed(maintainer, dust);
        e.claimDust();
        assertEq(maintainer.balance, mBefore + dust);
        assertEq(address(e).balance, 0);
    }

    function test_claimDust_zeroCheckInsAllToDust() public {
        _register(alice);
        _register(bob);
        _toSettled(); // nobody checked in
        uint256 all = address(e).balance;
        assertEq(all, 2 * DEPOSIT);
        uint256 mBefore = maintainer.balance;
        e.claimDust();
        assertEq(maintainer.balance, mBefore + all);
        assertEq(address(e).balance, 0);
    }

    function test_claimDust_revertsBeforeSettled() public {
        _register(alice);
        _toDispute();
        vm.expectRevert(IKodylEvent.NotSettled.selector);
        e.claimDust();
    }

    // ======================================================================
    // cancelEvent / setMetadataURI
    // ======================================================================

    function test_cancelEvent_happyPath() public {
        vm.expectEmit(false, false, false, false);
        emit EventCancelled();
        vm.prank(organizer);
        e.cancelEvent();
        assertEq(e.cancelled(), true);
    }

    function test_cancelEvent_revertsWhenNotOrganizer() public {
        vm.prank(alice);
        vm.expectRevert(IKodylEvent.NotOrganizer.selector);
        e.cancelEvent();
    }

    function test_cancelEvent_revertsAfterStart() public {
        _toActive();
        vm.prank(organizer);
        vm.expectRevert(IKodylEvent.EventAlreadyStarted.selector);
        e.cancelEvent();
    }

    function test_setMetadataURI_onlyOrganizer() public {
        vm.expectEmit(false, false, false, true);
        emit MetadataUpdated("ipfs://new");
        vm.prank(organizer);
        e.setMetadataURI("ipfs://new");
        assertEq(e.metadataURI(), "ipfs://new");

        vm.prank(alice);
        vm.expectRevert(IKodylEvent.NotOrganizer.selector);
        e.setMetadataURI("ipfs://evil");
    }

    // ======================================================================
    // receive
    // ======================================================================

    function test_receive_rejectsDirectETH() public {
        vm.deal(alice, 1 ether);
        vm.prank(alice);
        (bool ok,) = address(e).call{value: 1 ether}("");
        assertEq(ok, false);
    }

    // ======================================================================
    // claimRefund (fix for the organizer-cancel deposit-lock bug)
    // ======================================================================

    /// @notice After the organizer cancels the event, a registered attendee can
    /// always reclaim their deposit via claimRefund - even past the cancellation
    /// deadline, where plain cancel() would revert. This is the refund path the
    /// spec promises for cancelled events.
    function test_claimRefund_afterEventCancelled() public {
        _register(alice);
        // Move past the cancellation deadline but stay before eventStart.
        vm.warp(cancellationDeadline + 1);
        assertEq(uint256(e.getState()), uint256(IKodylEvent.State.Registration));

        vm.prank(organizer);
        e.cancelEvent();

        // Plain cancel() still reverts past the deadline...
        vm.prank(alice);
        vm.expectRevert(IKodylEvent.CancellationDeadlinePassed.selector);
        e.cancel();

        // ...but claimRefund recovers the deposit.
        uint256 balBefore = alice.balance;
        vm.expectEmit(true, false, false, true);
        emit RefundClaimed(alice, DEPOSIT);
        vm.prank(alice);
        e.claimRefund();

        assertEq(alice.balance, balBefore + DEPOSIT);
        assertEq(uint256(e.attendees(alice)), uint256(IKodylEvent.AttendeeStatus.Cancelled));
        assertEq(e.registeredCount(), 0);
        assertEq(address(e).balance, 0);
    }

    function test_claimRefund_revertsWhenNotCancelled() public {
        _register(alice);
        vm.prank(alice);
        vm.expectRevert(IKodylEvent.EventNotCancelled.selector);
        e.claimRefund();
    }

    function test_claimRefund_revertsWhenNotRegistered() public {
        vm.prank(organizer);
        e.cancelEvent();
        // bob never registered
        vm.prank(bob);
        vm.expectRevert(
            abi.encodeWithSelector(
                IKodylEvent.InvalidAttendeeStatus.selector,
                IKodylEvent.AttendeeStatus.None,
                IKodylEvent.AttendeeStatus.Registered
            )
        );
        e.claimRefund();
    }

    function test_claimRefund_cannotClaimTwice() public {
        _register(alice);
        vm.prank(organizer);
        e.cancelEvent();
        vm.prank(alice);
        e.claimRefund();
        // second attempt: status is now Cancelled, not Registered
        vm.prank(alice);
        vm.expectRevert(
            abi.encodeWithSelector(
                IKodylEvent.InvalidAttendeeStatus.selector,
                IKodylEvent.AttendeeStatus.Cancelled,
                IKodylEvent.AttendeeStatus.Registered
            )
        );
        e.claimRefund();
    }
}
