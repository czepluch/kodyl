// SPDX-License-Identifier: MIT
pragma solidity ^0.8.33;

import {Test} from "forge-std/Test.sol";
import {CoreDeploy} from "./CoreDeploy.sol";
// KodylAbi is the single hand-authored interface (functions, events, errors):
// the same source `forge inspect` turns into the frontend ABI, so the tests
// exercise exactly what ships. The IKodyl alias is a re-export for the sibling
// suites that import the interface from here under its old name.
import {KodylAbi} from "./KodylAbi.sol";
import {KodylAbi as IKodyl} from "./KodylAbi.sol";

contract KodylTest is Test {
    event EventCreated(
        uint256 indexed eventId, address indexed organizer, uint256 depositAmount, uint256 eventStart, uint256 eventEnd
    );
    event Registered(uint256 indexed eventId, address indexed attendee);
    event RegistrationCancelled(uint256 indexed eventId, address indexed attendee);
    event CheckedIn(uint256 indexed eventId, address indexed attendee);
    event Claimed(uint256 indexed eventId, address indexed attendee, uint256 amount);
    event RefundClaimed(uint256 indexed eventId, address indexed attendee, uint256 amount);
    event EventCancelled(uint256 indexed eventId);
    event MetadataUpdated(uint256 indexed eventId, string newURI);
    event DustClaimed(uint256 indexed eventId, address indexed recipient, uint256 amount);
    event MaintainerUpdated(address indexed oldMaintainer, address indexed newMaintainer);

    // AttendeeStatus / State ordinals.
    uint256 internal constant NONE = 0;
    uint256 internal constant REGISTERED = 1;
    uint256 internal constant CANCELLED_S = 2;
    uint256 internal constant CHECKED_IN = 3;
    uint256 internal constant CLAIMED = 4;
    uint256 internal constant ST_REGISTRATION = 0;
    uint256 internal constant ST_ACTIVE = 1;
    uint256 internal constant ST_DISPUTE = 2;
    uint256 internal constant ST_SETTLED = 3;
    uint256 internal constant ST_CANCELLED = 4;

    uint256 internal constant START_TS = 1_700_000_000;
    uint256 internal constant DEPOSIT = 1 ether;

    address internal maintainer = makeAddr("maintainer");
    address internal organizer = makeAddr("organizer");
    address internal alice = makeAddr("alice");
    address internal bob = makeAddr("bob");
    address internal carol = makeAddr("carol");

    KodylAbi internal k;
    uint256 internal eventStart;
    uint256 internal eventEnd;
    uint256 internal disputePeriod = 1 days;

    function setUp() public {
        vm.warp(START_TS);
        k = KodylAbi(payable(CoreDeploy.deploy("Kodyl", abi.encode(maintainer))));
        eventStart = START_TS + 30 days;
        eventEnd = eventStart + 1 days;
    }

    function _create() internal returns (uint256) {
        return _createAs(organizer, 0);
    }

    function _createAs(address org, uint256 cap) internal returns (uint256) {
        vm.prank(org);
        return k.createEvent(DEPOSIT, eventStart - 7 days, eventStart, eventEnd, disputePeriod, cap, "ipfs://meta");
    }

    function _register(uint256 eid, address who) internal {
        vm.deal(who, DEPOSIT);
        vm.prank(who);
        k.register{value: DEPOSIT}(eid);
    }

    function _toActive() internal {
        vm.warp(eventStart);
    }

    function _toSettled() internal {
        vm.warp(eventEnd + disputePeriod + 1);
    }

    // ==================================================================
    // constructor
    // ==================================================================

    function test_constructor_rejectsZeroMaintainer() public {
        // The constructor refuses a zero maintainer; tryDeploy surfaces the
        // revert as address(0) instead of aborting the test.
        assertEq(CoreDeploy.tryDeploy("Kodyl", abi.encode(address(0))), address(0));
        assertTrue(CoreDeploy.tryDeploy("Kodyl", abi.encode(maintainer)) != address(0));
    }

    // ==================================================================
    // creation
    // ==================================================================

    function test_createEvent_sequentialIdsAndStorage() public {
        uint256 a = _create();
        vm.warp(START_TS + 1);
        uint256 b = _createAs(organizer, 5);
        assertEq(a, 1);
        assertEq(b, 2);
        assertEq(k.eventCount(), 2);

        (address org, uint256 dep, uint256 deadline, uint256 start, uint256 end_, uint256 dispute, uint256 cap) =
            k.getEvent(1);
        assertEq(org, organizer);
        assertEq(dep, DEPOSIT);
        assertEq(deadline, eventStart - 7 days);
        assertEq(start, eventStart);
        assertEq(end_, eventEnd);
        assertEq(dispute, disputePeriod);
        assertEq(cap, 0);
        (,,,,,, uint256 cap2) = k.getEvent(2);
        assertEq(cap2, 5);

        assertEq(k.organizer(1), organizer);
        assertEq(k.metadataURI(1), "ipfs://meta");
        assertEq(k.cancelled(1), false);
    }

    function test_createEvent_emits() public {
        vm.expectEmit(true, true, false, true);
        emit EventCreated(1, organizer, DEPOSIT, eventStart, eventEnd);
        _create();
    }

    function test_unknownEventReverts() public {
        vm.expectRevert(KodylAbi.EventNotFound.selector);
        k.getEvent(1);
        vm.expectRevert(KodylAbi.EventNotFound.selector);
        k.getState(99);
        vm.deal(alice, DEPOSIT);
        vm.prank(alice);
        vm.expectRevert(KodylAbi.EventNotFound.selector);
        k.register{value: DEPOSIT}(1);
        vm.expectRevert(KodylAbi.EventNotFound.selector);
        k.claim(1);
        vm.prank(organizer);
        vm.expectRevert(KodylAbi.EventNotFound.selector);
        k.checkIn(1, alice);
        vm.expectRevert(KodylAbi.EventNotFound.selector);
        k.claimDust(1);
        vm.expectRevert(KodylAbi.EventNotFound.selector);
        k.organizer(99);
        vm.expectRevert(KodylAbi.EventNotFound.selector);
        k.metadataURI(99);
        vm.expectRevert(KodylAbi.EventNotFound.selector);
        k.rewardPerAttendee(99);
        vm.prank(alice);
        vm.expectRevert(KodylAbi.EventNotFound.selector);
        k.cancel(99);
        vm.prank(alice);
        vm.expectRevert(KodylAbi.EventNotFound.selector);
        k.claimRefund(99);
        vm.prank(organizer);
        vm.expectRevert(KodylAbi.EventNotFound.selector);
        k.cancelEvent(99);
        vm.prank(organizer);
        vm.expectRevert(KodylAbi.EventNotFound.selector);
        k.setMetadataURI(99, "ipfs://nope");
        // checkInBatch dispatches through the fallback: raw call, same error.
        (bool ok, bytes memory ret) = address(k).call(abi.encodeCall(KodylAbi.checkInBatch, (99, new address[](0))));
        assertFalse(ok);
        assertEq(ret, abi.encodeWithSelector(KodylAbi.EventNotFound.selector));
    }

    function test_unknownEventZeroGetters() public view {
        // Deliberate two-tier read surface: id-validating getters revert
        // (above), plain counter and mapping reads just return the zero slot.
        assertEq(k.attendees(99, alice), NONE);
        assertEq(k.cancelled(99), false);
        assertEq(k.registeredCount(99), 0);
        assertEq(k.checkedInCount(99), 0);
        assertEq(k.claimedCount(99), 0);
        assertEq(k.held(99), 0);
    }

    // ==================================================================
    // validation (through the real createEvent API)
    // ==================================================================

    function _expectInvalid(string memory reason) internal {
        vm.expectRevert(abi.encodeWithSelector(KodylAbi.InvalidEventParameters.selector, reason));
    }

    function test_validation_reverts() public {
        _expectInvalid("Deposit must be > 0");
        k.createEvent(0, eventStart - 7 days, eventStart, eventEnd, 1 days, 0, "");

        _expectInvalid("Event must start in future");
        k.createEvent(DEPOSIT, START_TS - 1, START_TS, eventEnd, 1 days, 0, "");

        _expectInvalid("Event end must be after start");
        k.createEvent(DEPOSIT, eventStart - 7 days, eventStart, eventStart, 1 days, 0, "");

        // Two-word reason (39 bytes).
        vm.warp(eventStart - 1 days);
        _expectInvalid("Cancellation deadline must be in future");
        k.createEvent(DEPOSIT, eventStart - 3 days, eventStart, eventEnd, 1 days, 0, "");
        vm.warp(START_TS);

        _expectInvalid("Dispute period too short");
        k.createEvent(DEPOSIT, eventStart - 7 days, eventStart, eventEnd, 59 minutes, 0, "");

        _expectInvalid("Dispute period too long");
        k.createEvent(DEPOSIT, eventStart - 7 days, eventStart, eventEnd, 31 days, 0, "");
    }

    function test_validation_deadlineBoundary() public {
        // At least 2h before the event; boundary inclusive.
        vm.prank(organizer);
        k.createEvent(DEPOSIT, eventStart - 2 hours, eventStart, eventEnd, 1 days, 0, "");

        _expectInvalid("Cancellation deadline too late");
        k.createEvent(DEPOSIT, eventStart - 1 hours, eventStart, eventEnd, 1 days, 0, "");

        _expectInvalid("Cancellation deadline too late");
        k.createEvent(DEPOSIT, eventStart + 12 hours, eventStart, eventEnd, 1 days, 0, "");
    }

    // ==================================================================
    // state derivation
    // ==================================================================

    function test_getState_transitionsOverTime() public {
        uint256 eid = _create();
        assertEq(k.getState(eid), ST_REGISTRATION);
        vm.warp(eventStart);
        assertEq(k.getState(eid), ST_ACTIVE);
        vm.warp(eventEnd);
        assertEq(k.getState(eid), ST_ACTIVE); // inclusive
        vm.warp(eventEnd + 1);
        assertEq(k.getState(eid), ST_DISPUTE);
        vm.warp(eventEnd + disputePeriod);
        assertEq(k.getState(eid), ST_DISPUTE); // inclusive
        vm.warp(eventEnd + disputePeriod + 1);
        assertEq(k.getState(eid), ST_SETTLED);
    }

    function test_getState_cancelledDominates() public {
        uint256 eid = _create();
        vm.prank(organizer);
        k.cancelEvent(eid);
        assertEq(k.getState(eid), ST_CANCELLED);
        _toSettled();
        assertEq(k.getState(eid), ST_CANCELLED);
    }

    // ==================================================================
    // register
    // ==================================================================

    function test_register_happyPath() public {
        uint256 eid = _create();
        vm.deal(alice, DEPOSIT);
        vm.expectEmit(true, true, false, false);
        emit Registered(eid, alice);
        vm.prank(alice);
        k.register{value: DEPOSIT}(eid);

        assertEq(k.attendees(eid, alice), REGISTERED);
        assertEq(k.registeredCount(eid), 1);
        assertEq(k.held(eid), DEPOSIT);
        assertEq(k.totalHeld(), DEPOSIT);
        assertEq(address(k).balance, DEPOSIT);
    }

    function test_register_revertsOnWrongDeposit() public {
        uint256 eid = _create();
        vm.deal(alice, 1 ether);
        vm.prank(alice);
        vm.expectRevert(abi.encodeWithSelector(KodylAbi.IncorrectDeposit.selector, DEPOSIT, 0.5 ether));
        k.register{value: 0.5 ether}(eid);

        // Overpay is rejected too: expected deposit first, received second.
        vm.deal(alice, 1.5 ether);
        vm.prank(alice);
        vm.expectRevert(abi.encodeWithSelector(KodylAbi.IncorrectDeposit.selector, DEPOSIT, 1.5 ether));
        k.register{value: 1.5 ether}(eid);
    }

    function test_register_revertsWhenAlreadyRegistered() public {
        uint256 eid = _create();
        _register(eid, alice);
        vm.deal(alice, DEPOSIT);
        vm.prank(alice);
        vm.expectRevert(KodylAbi.AlreadyRegistered.selector);
        k.register{value: DEPOSIT}(eid);
    }

    function test_register_revertsAfterStart() public {
        uint256 eid = _create();
        _toActive();
        vm.deal(alice, DEPOSIT);
        vm.prank(alice);
        vm.expectRevert(KodylAbi.RegistrationClosed.selector);
        k.register{value: DEPOSIT}(eid);
    }

    function test_register_revertsWhenFull() public {
        uint256 eid = _createAs(organizer, 1);
        _register(eid, alice);
        vm.deal(bob, DEPOSIT);
        vm.prank(bob);
        vm.expectRevert(KodylAbi.EventFull.selector);
        k.register{value: DEPOSIT}(eid);

        // A cancellation frees the slot: the next registrant fits, then the
        // event is full again for the one after.
        vm.prank(alice);
        k.cancel(eid);
        _register(eid, bob);
        assertEq(k.registeredCount(eid), 1);
        vm.deal(carol, DEPOSIT);
        vm.prank(carol);
        vm.expectRevert(KodylAbi.EventFull.selector);
        k.register{value: DEPOSIT}(eid);
    }

    function test_register_reRegisterAfterCancel() public {
        uint256 eid = _create();
        _register(eid, alice);
        vm.prank(alice);
        k.cancel(eid);
        assertEq(k.attendees(eid, alice), CANCELLED_S);
        _register(eid, alice);
        assertEq(k.attendees(eid, alice), REGISTERED);
        assertEq(k.registeredCount(eid), 1);

        // The re-registered attendee goes through the normal lifecycle.
        _toActive();
        vm.prank(organizer);
        k.checkIn(eid, alice);
        _toSettled();
        uint256 balBefore = alice.balance;
        vm.prank(alice);
        k.claim(eid);
        assertEq(alice.balance, balBefore + DEPOSIT); // no no-shows: deposit only
        assertEq(k.attendees(eid, alice), CLAIMED);
        assertEq(k.totalHeld(), 0);
    }

    function test_register_isolatedAcrossEvents() public {
        uint256 a = _create();
        vm.warp(START_TS + 1);
        uint256 b = _createAs(carol, 0);

        _register(a, alice);
        assertEq(k.attendees(a, alice), REGISTERED);
        assertEq(k.attendees(b, alice), NONE);
        assertEq(k.registeredCount(a), 1);
        assertEq(k.registeredCount(b), 0);

        _register(b, alice);
        assertEq(k.registeredCount(b), 1);
        assertEq(k.totalHeld(), 2 * DEPOSIT);
        assertEq(k.held(a), DEPOSIT);
        assertEq(k.held(b), DEPOSIT);
    }

    // ==================================================================
    // cancel / cancelEvent / claimRefund
    // ==================================================================

    function test_cancel_refundsAndUpdatesLedger() public {
        uint256 eid = _create();
        _register(eid, alice);
        uint256 balBefore = alice.balance;
        vm.expectEmit(true, true, false, false);
        emit RegistrationCancelled(eid, alice);
        vm.prank(alice);
        k.cancel(eid);
        assertEq(alice.balance, balBefore + DEPOSIT);
        assertEq(k.registeredCount(eid), 0);
        assertEq(k.held(eid), 0);
        assertEq(k.totalHeld(), 0);
    }

    function test_cancel_revertsAfterDeadline() public {
        uint256 eid = _create();
        _register(eid, alice);
        vm.warp(eventStart - 7 days + 1);
        vm.prank(alice);
        vm.expectRevert(KodylAbi.CancellationDeadlinePassed.selector);
        k.cancel(eid);
    }

    function test_cancel_atExactDeadline() public {
        // The deadline itself is inclusive (only strict > reverts).
        uint256 eid = _create();
        _register(eid, alice);
        vm.warp(eventStart - 7 days);
        uint256 balBefore = alice.balance;
        vm.prank(alice);
        k.cancel(eid);
        assertEq(alice.balance, balBefore + DEPOSIT);
        assertEq(k.registeredCount(eid), 0);
        assertEq(k.held(eid), 0);
        assertEq(k.totalHeld(), 0);
    }

    function test_cancel_revertsWhenNotRegistered() public {
        uint256 eid = _create();
        vm.prank(alice);
        vm.expectRevert(abi.encodeWithSelector(KodylAbi.InvalidAttendeeStatus.selector, 0, 1));
        k.cancel(eid);
    }

    function test_cancelEvent_lifecycle() public {
        uint256 eid = _create();
        vm.expectEmit(true, false, false, false);
        emit EventCancelled(eid);
        vm.prank(organizer);
        k.cancelEvent(eid);
        assertEq(k.cancelled(eid), true);

        vm.prank(alice);
        vm.expectRevert(KodylAbi.NotOrganizer.selector);
        k.cancelEvent(eid);
    }

    function test_cancelEvent_revertsAfterStart() public {
        uint256 eid = _create();
        _toActive();
        vm.prank(organizer);
        vm.expectRevert(KodylAbi.EventAlreadyStarted.selector);
        k.cancelEvent(eid);
    }

    function test_cancelEvent_organizerScopedPerEvent() public {
        uint256 a = _create();
        vm.warp(START_TS + 1);
        uint256 b = _createAs(carol, 0);
        // organizer of a cannot cancel carol's event.
        vm.prank(organizer);
        vm.expectRevert(KodylAbi.NotOrganizer.selector);
        k.cancelEvent(b);
        vm.prank(carol);
        k.cancelEvent(b);
        assertEq(k.cancelled(b), true);
        assertEq(k.cancelled(a), false);
    }

    function test_claimRefund_afterCancelEvenPastDeadline() public {
        uint256 eid = _create();
        _register(eid, alice);
        vm.warp(eventStart - 7 days + 1); // past cancellation deadline
        vm.prank(organizer);
        k.cancelEvent(eid);

        vm.prank(alice);
        vm.expectRevert(KodylAbi.CancellationDeadlinePassed.selector);
        k.cancel(eid);

        uint256 balBefore = alice.balance;
        vm.expectEmit(true, true, false, true);
        emit RefundClaimed(eid, alice, DEPOSIT);
        vm.prank(alice);
        k.claimRefund(eid);
        assertEq(alice.balance, balBefore + DEPOSIT);
        assertEq(k.totalHeld(), 0);

        // No double refund.
        vm.prank(alice);
        vm.expectRevert(abi.encodeWithSelector(KodylAbi.InvalidAttendeeStatus.selector, 2, 1));
        k.claimRefund(eid);
    }

    function test_claimRefund_revertsWhenNotCancelled() public {
        uint256 eid = _create();
        _register(eid, alice);
        vm.prank(alice);
        vm.expectRevert(KodylAbi.EventNotCancelled.selector);
        k.claimRefund(eid);
    }

    // Regression (review finding, high): check-in must be rejected on a
    // cancelled event, otherwise a checked-in attendee could never recover
    // their deposit (claimRefund needs Registered, claim needs Settled which a
    // cancelled event never reaches). The refund path must stay open.
    function test_checkIn_rejectedAfterCancelSoRefundStaysOpen() public {
        uint256 eid = _create();
        _register(eid, alice);
        vm.warp(eventStart - 7 days + 1); // past the cancellation deadline
        vm.prank(organizer);
        k.cancelEvent(eid);

        // Into the would-be check-in window; check-in must now revert.
        _toActive();
        vm.prank(organizer);
        vm.expectRevert(KodylAbi.CheckInWindowClosed.selector);
        k.checkIn(eid, alice);

        address[] memory batch = new address[](1);
        batch[0] = alice;
        vm.prank(organizer);
        vm.expectRevert(KodylAbi.CheckInWindowClosed.selector);
        k.checkInBatch(eid, batch);

        // alice is still Registered and can reclaim her deposit.
        assertEq(k.attendees(eid, alice), REGISTERED);
        uint256 balBefore = alice.balance;
        vm.prank(alice);
        k.claimRefund(eid);
        assertEq(alice.balance, balBefore + DEPOSIT);
        assertEq(k.totalHeld(), 0);
    }

    // Regression (review finding, critical): forced ETH (selfdestruct/coinbase)
    // pushes the contract balance above the ledger and cannot be rejected. With
    // a strict balance == totalHeld assert this bricked every fund-moving flow
    // for every event permanently; the invariant is >= so flows keep working
    // and the surplus is simply stuck.
    function test_forcedETH_doesNotBrickFlows() public {
        uint256 eid = _create();
        _register(eid, alice);
        _register(eid, bob);

        // Force ETH in without calling the contract (mimics selfdestrict/
        // block-reward payment, which vm.deal on the contract reproduces for
        // accounting purposes: raises balance without touching totalHeld).
        vm.deal(address(k), address(k).balance + 1 wei);
        assertGt(address(k).balance, k.totalHeld());

        // Every fund-moving flow must still work.
        vm.prank(alice);
        k.cancel(eid); // refund path
        assertEq(k.registeredCount(eid), 1);

        _toActive();
        vm.prank(organizer);
        k.checkIn(eid, bob);
        _toSettled();
        uint256 balBefore = bob.balance;
        vm.prank(bob);
        k.claim(eid); // payout path
        assertEq(bob.balance, balBefore + DEPOSIT); // no no-shows -> no reward

        // The forced wei is stranded but harmless.
        assertEq(address(k).balance, 1 wei);
        assertEq(k.totalHeld(), 0);
    }

    // ==================================================================
    // check-in
    // ==================================================================

    function test_checkIn_happyAndSkip() public {
        uint256 eid = _create();
        _register(eid, alice);
        _toActive();
        vm.expectEmit(true, true, false, false);
        emit CheckedIn(eid, alice);
        vm.prank(organizer);
        k.checkIn(eid, alice);
        assertEq(k.attendees(eid, alice), CHECKED_IN);
        assertEq(k.checkedInCount(eid), 1);

        // Unregistered bob: silent skip.
        vm.prank(organizer);
        k.checkIn(eid, bob);
        assertEq(k.attendees(eid, bob), NONE);
        assertEq(k.checkedInCount(eid), 1);
    }

    function test_checkIn_revertsOutsideWindow() public {
        uint256 eid = _create();
        _register(eid, alice);
        vm.prank(organizer);
        vm.expectRevert(KodylAbi.CheckInWindowClosed.selector);
        k.checkIn(eid, alice);
    }

    function test_checkIn_organizerScopedPerEvent() public {
        uint256 a = _create();
        vm.warp(START_TS + 1);
        uint256 b = _createAs(carol, 0);
        _register(b, alice);
        _toActive();
        vm.prank(organizer); // organizer of a, not b
        vm.expectRevert(KodylAbi.NotOrganizer.selector);
        k.checkIn(b, alice);
    }

    function test_checkIn_windowBackEdge() public {
        uint256 eid = _create();
        _register(eid, alice);
        _register(eid, bob);
        // Last valid instant: the dispute period end is inclusive.
        vm.warp(eventEnd + disputePeriod);
        vm.prank(organizer);
        k.checkIn(eid, alice);
        assertEq(k.attendees(eid, alice), CHECKED_IN);

        // One second later the event is Settled and both paths close.
        vm.warp(eventEnd + disputePeriod + 1);
        vm.prank(organizer);
        vm.expectRevert(KodylAbi.CheckInWindowClosed.selector);
        k.checkIn(eid, bob);
        address[] memory batch = new address[](1);
        batch[0] = bob;
        vm.prank(organizer);
        vm.expectRevert(KodylAbi.CheckInWindowClosed.selector);
        k.checkInBatch(eid, batch);
    }

    function test_checkInBatch_throughTypedInterface() public {
        uint256 eid = _create();
        _register(eid, alice);
        _register(eid, bob);
        _toActive();

        address[] memory batch = new address[](3);
        batch[0] = alice;
        batch[1] = carol; // unregistered: skipped
        batch[2] = bob;

        vm.prank(organizer);
        k.checkInBatch(eid, batch);
        assertEq(k.attendees(eid, alice), CHECKED_IN);
        assertEq(k.attendees(eid, bob), CHECKED_IN);
        assertEq(k.attendees(eid, carol), NONE);
        assertEq(k.checkedInCount(eid), 2);
    }

    function test_checkInBatch_revertsWhenTooLarge() public {
        uint256 eid = _create();
        _toActive();
        address[] memory batch = new address[](101);
        vm.prank(organizer);
        vm.expectRevert(abi.encodeWithSelector(KodylAbi.BatchTooLarge.selector, 101, 100));
        k.checkInBatch(eid, batch);
    }

    function test_checkInBatch_revertsForNonOrganizer() public {
        uint256 eid = _create();
        _toActive();
        address[] memory batch = new address[](1);
        batch[0] = alice;
        vm.prank(alice);
        vm.expectRevert(KodylAbi.NotOrganizer.selector);
        k.checkInBatch(eid, batch);
    }

    function test_checkInBatch_maxSizeBoundary() public {
        // Exactly MAX_BATCH_SIZE registered attendees go through in one call.
        uint256 eid = _create();
        address[] memory batch = new address[](100);
        for (uint256 i = 0; i < 100; i++) {
            address a = address(uint160(0xC0FFEE00 + i));
            batch[i] = a;
            _register(eid, a);
        }
        _toActive();
        vm.prank(organizer);
        k.checkInBatch(eid, batch);
        assertEq(k.checkedInCount(eid), 100);
    }

    function test_checkInBatch_emptyArrayIsNoOp() public {
        uint256 eid = _create();
        _register(eid, alice);
        _toActive();
        vm.prank(organizer);
        k.checkInBatch(eid, new address[](0));
        assertEq(k.checkedInCount(eid), 0);
        assertEq(k.attendees(eid, alice), REGISTERED);
    }

    function test_checkInBatch_duplicatesCountOnce() public {
        uint256 eid = _create();
        _register(eid, alice);
        _toActive();
        address[] memory batch = new address[](2);
        batch[0] = alice;
        batch[1] = alice;
        vm.prank(organizer);
        k.checkInBatch(eid, batch);
        assertEq(k.attendees(eid, alice), CHECKED_IN);
        assertEq(k.checkedInCount(eid), 1); // second entry hits the CheckedIn skip
    }

    // ==================================================================
    // checkInBatch decoder (raw calldata against the hand-rolled fallback)
    // ==================================================================

    function test_checkInBatch_selectorOnlyCalldata() public {
        // 4-byte calldata: every missing word reads as zero, so eid decodes
        // as 0, which is never a real event.
        _create();
        (bool ok, bytes memory ret) = address(k).call(abi.encodePacked(KodylAbi.checkInBatch.selector));
        assertFalse(ok);
        assertEq(ret, abi.encodeWithSelector(KodylAbi.EventNotFound.selector));
    }

    function test_checkInBatch_offsetPastCalldataIsNoOp() public {
        uint256 eid = _create();
        _register(eid, alice);
        _toActive();
        // Offset points past calldatasize: the length word reads as zero, so
        // the call is a silent no-op rather than a revert.
        bytes memory payload = abi.encodePacked(KodylAbi.checkInBatch.selector, eid, uint256(0x1000));
        vm.prank(organizer);
        (bool ok, bytes memory ret) = address(k).call(payload);
        assertTrue(ok);
        assertEq(ret.length, 0);
        assertEq(k.checkedInCount(eid), 0);
        assertEq(k.attendees(eid, alice), REGISTERED);
    }

    function test_checkInBatch_allOnesOffsetWrapsIntoBatchTooLarge() public {
        uint256 eid = _create();
        _toActive();
        // lenPtr = 4 + (2^256 - 1) wraps to 3, so the length word is read
        // from inside the calldata prefix: the last selector byte followed
        // by the first 31 bytes of the eid word. That is astronomically
        // large, so the size cap trips - not a silent no-op.
        bytes4 sel = KodylAbi.checkInBatch.selector;
        uint256 wrappedLen = (uint256(uint8(sel[3])) << 248) | (eid >> 8);
        assertGt(wrappedLen, 100); // sanity: the selector byte is nonzero
        bytes memory payload = abi.encodePacked(sel, eid, type(uint256).max);
        vm.prank(organizer);
        (bool ok, bytes memory ret) = address(k).call(payload);
        assertFalse(ok);
        assertEq(ret, abi.encodeWithSelector(KodylAbi.BatchTooLarge.selector, wrappedLen, 100));
    }

    function test_checkInBatch_dirtyAddressWordReverts() public {
        uint256 eid = _create();
        _register(eid, alice);
        _toActive();
        bytes4 sel = KodylAbi.checkInBatch.selector;
        // Standard layout (array head at offset 0x40 past the selector), one
        // element, with a single dirty bit above the address range. Strict
        // decoding rejects it - same error as the std's typed address paths.
        uint256 dirty = (uint256(1) << 160) | uint256(uint160(alice));
        bytes memory payload = abi.encodePacked(sel, eid, uint256(0x40), uint256(1), dirty);
        vm.prank(organizer);
        (bool ok, bytes memory ret) = address(k).call(payload);
        assertFalse(ok);
        assertEq(ret, abi.encodeWithSelector(KodylAbi.DirtyHigherBitsForAddress.selector));
        assertEq(k.attendees(eid, alice), REGISTERED);
        assertEq(k.checkedInCount(eid), 0);

        // The clean variant of the same batch goes through.
        bytes memory clean = abi.encodePacked(sel, eid, uint256(0x40), uint256(1), uint256(uint160(alice)));
        vm.prank(organizer);
        (ok, ret) = address(k).call(clean);
        assertTrue(ok);
        assertEq(k.attendees(eid, alice), CHECKED_IN);
        assertEq(k.checkedInCount(eid), 1);
    }

    function test_checkInBatch_rejectsValueWithEmptyRevert() public {
        uint256 eid = _create();
        _register(eid, alice);
        _toActive();
        address[] memory batch = new address[](1);
        batch[0] = alice;
        vm.deal(organizer, 1);
        vm.prank(organizer);
        (bool ok, bytes memory ret) = address(k).call{value: 1}(abi.encodeCall(KodylAbi.checkInBatch, (eid, batch)));
        assertFalse(ok);
        assertEq(ret.length, 0); // the fallback's value guard reverts empty
        assertEq(k.checkedInCount(eid), 0);
    }

    // ==================================================================
    // claim + dust
    // ==================================================================

    function test_claim_paysDepositPlusReward() public {
        uint256 eid = _create();
        _register(eid, alice);
        _register(eid, bob);
        _register(eid, carol);
        _toActive();
        vm.startPrank(organizer);
        k.checkIn(eid, alice);
        k.checkIn(eid, bob);
        vm.stopPrank();
        _toSettled();

        assertEq(k.rewardPerAttendee(eid), 0.5 ether); // carol forfeits, split by 2

        uint256 balBefore = alice.balance;
        vm.expectEmit(true, true, false, true);
        emit Claimed(eid, alice, DEPOSIT + 0.5 ether);
        vm.prank(alice);
        k.claim(eid);
        assertEq(alice.balance, balBefore + DEPOSIT + 0.5 ether);
        assertEq(k.attendees(eid, alice), CLAIMED);
        assertEq(k.claimedCount(eid), 1);
        assertEq(k.totalHeld(), 3 * DEPOSIT - (DEPOSIT + 0.5 ether));

        // Claimed is terminal: a second claim names the Claimed ordinal.
        vm.prank(alice);
        vm.expectRevert(abi.encodeWithSelector(KodylAbi.InvalidAttendeeStatus.selector, 4, 3));
        k.claim(eid);
        // carol registered but never checked in: not claimable either.
        vm.prank(carol);
        vm.expectRevert(abi.encodeWithSelector(KodylAbi.InvalidAttendeeStatus.selector, 1, 3));
        k.claim(eid);
    }

    function test_claim_revertsBeforeSettledAndWhenNotCheckedIn() public {
        uint256 eid = _create();
        _register(eid, alice);
        _toActive();
        vm.prank(organizer);
        k.checkIn(eid, alice);
        vm.prank(alice);
        vm.expectRevert(KodylAbi.NotSettled.selector);
        k.claim(eid);

        _toSettled();
        vm.prank(bob);
        vm.expectRevert(abi.encodeWithSelector(KodylAbi.InvalidAttendeeStatus.selector, 0, 3));
        k.claim(eid);
    }

    function test_claim_andDustRevertDuringDispute() public {
        uint256 eid = _create();
        _register(eid, alice);
        _toActive();
        vm.prank(organizer);
        k.checkIn(eid, alice);
        // Last instant of Dispute (inclusive back edge): still not Settled.
        vm.warp(eventEnd + disputePeriod);
        vm.prank(alice);
        vm.expectRevert(KodylAbi.NotSettled.selector);
        k.claim(eid);
        vm.expectRevert(KodylAbi.NotSettled.selector);
        k.claimDust(eid);
    }

    function test_claimDust_remainderAfterAllClaims() public {
        uint256 eid = _create();
        _register(eid, alice);
        _register(eid, bob);
        _register(eid, carol);
        address dave = makeAddr("dave");
        _register(eid, dave);
        _toActive();
        vm.startPrank(organizer);
        k.checkIn(eid, alice);
        k.checkIn(eid, bob);
        k.checkIn(eid, carol);
        vm.stopPrank();
        _toSettled();
        // dave forfeits 1 ETH across 3 claimants: 1 wei remainder.
        vm.prank(alice);
        k.claim(eid);
        vm.prank(bob);
        k.claim(eid);
        vm.prank(carol);
        k.claim(eid);

        uint256 dust = k.held(eid);
        assertEq(dust, 1 ether % 3);
        uint256 mBefore = maintainer.balance;
        vm.expectEmit(true, true, false, true);
        emit DustClaimed(eid, maintainer, dust);
        k.claimDust(eid);
        assertEq(maintainer.balance, mBefore + dust);
        assertEq(k.held(eid), 0);
        assertEq(k.totalHeld(), 0);
    }

    function test_claimDust_zeroCheckInsAllToDust() public {
        uint256 eid = _create();
        _register(eid, alice);
        _register(eid, bob);
        _toSettled();
        uint256 mBefore = maintainer.balance;
        k.claimDust(eid);
        assertEq(maintainer.balance, mBefore + 2 * DEPOSIT);
        assertEq(k.totalHeld(), 0);
    }

    function test_claimDust_gatesAndTimeout() public {
        uint256 eid = _create();
        _register(eid, alice);
        _register(eid, bob);
        _toActive();
        vm.prank(organizer);
        k.checkIn(eid, alice);

        vm.expectRevert(KodylAbi.NotSettled.selector);
        k.claimDust(eid);

        _toSettled();
        // alice has not claimed: neither allClaimed nor timeout.
        vm.expectRevert(KodylAbi.DustNotClaimable.selector);
        k.claimDust(eid);

        // The timeout is strict: at exactly end + dispute + 30 days the
        // sweep is still gated.
        vm.warp(eventEnd + disputePeriod + 30 days);
        vm.expectRevert(KodylAbi.DustNotClaimable.selector);
        k.claimDust(eid);

        // After the timeout the pot (including alice's unclaimed payout)
        // sweeps to the maintainer.
        vm.warp(eventEnd + disputePeriod + 30 days + 1);
        uint256 mBefore = maintainer.balance;
        k.claimDust(eid);
        assertEq(maintainer.balance, mBefore + 2 * DEPOSIT);
    }

    function test_claimDust_revertsWhenPotEmpty() public {
        uint256 eid = _create();
        _register(eid, alice);
        _register(eid, bob);
        _register(eid, carol);
        _toActive();
        vm.startPrank(organizer);
        k.checkIn(eid, alice);
        k.checkIn(eid, bob);
        vm.stopPrank();
        _toSettled();
        // carol's forfeited 1 ETH splits evenly across 2 claimants: after
        // both claims the pot is exactly zero.
        vm.prank(alice);
        k.claim(eid);
        vm.prank(bob);
        k.claim(eid);
        assertEq(k.held(eid), 0);
        // All claims are out, but there is nothing to sweep.
        vm.expectRevert(KodylAbi.DustNotClaimable.selector);
        k.claimDust(eid);
    }

    function test_claimDust_paysRotatedMaintainer() public {
        uint256 eid = _create();
        _register(eid, alice); // alice no-shows: the whole pot is dust
        _toSettled();

        address next = makeAddr("nextMaintainer");
        vm.prank(maintainer);
        k.setMaintainer(next);

        uint256 oldBal = maintainer.balance;
        uint256 newBal = next.balance;
        vm.expectEmit(true, true, false, true);
        emit DustClaimed(eid, next, DEPOSIT); // recipient is the NEW maintainer
        k.claimDust(eid);
        assertEq(next.balance, newBal + DEPOSIT);
        assertEq(maintainer.balance, oldBal); // old maintainer gets nothing
        assertEq(k.totalHeld(), 0);
    }

    function test_claimDust_isolatedPerEvent() public {
        uint256 a = _create();
        vm.warp(START_TS + 1);
        uint256 b = _createAs(carol, 0);
        _register(a, alice);
        _register(b, bob);
        _toSettled(); // nobody checked in anywhere

        k.claimDust(a);
        // Event b's pot is untouched.
        assertEq(k.held(b), DEPOSIT);
        assertEq(k.totalHeld(), DEPOSIT);
        assertEq(address(k).balance, DEPOSIT);
        // bob's money is still claimable as dust for b.
        k.claimDust(b);
        assertEq(k.totalHeld(), 0);
    }

    // ==================================================================
    // stray ETH / unknown selectors
    // ==================================================================

    function test_fallback_rejectsPlainTransferAndUnknownSelector() public {
        vm.deal(alice, 1 ether);
        vm.prank(alice);
        (bool ok,) = address(k).call{value: 1 ether}("");
        assertFalse(ok, "plain transfer must revert");
        (ok,) = address(k).call(abi.encodeWithSignature("nope()"));
        assertFalse(ok, "unknown selector must revert");
    }

    function test_fallback_shortCalldataRevertsEmpty() public {
        // 2 bytes: not empty (so not the TransferFailed path), too short for
        // a selector - rejected with empty revert data.
        (bool ok, bytes memory ret) = address(k).call(hex"1234");
        assertFalse(ok);
        assertEq(ret.length, 0);
    }

    function test_nonPayable_rejectsValueWithStdError() public {
        uint256 eid = _create();
        _register(eid, alice);
        vm.deal(alice, 1);
        vm.prank(alice);
        (bool ok, bytes memory ret) = address(k).call{value: 1}(abi.encodeCall(KodylAbi.cancel, (eid)));
        assertFalse(ok);
        // The std dispatcher's non-payable guard: exactly its 4-byte selector.
        assertEq(ret, abi.encodeWithSelector(KodylAbi.NonPayableReceivedValue.selector));
        assertEq(ret, hex"b5988ea3"); // pins the raw selector bytes too
        assertEq(k.attendees(eid, alice), REGISTERED); // nothing changed
    }

    // ==================================================================
    // maintainer + constants
    // ==================================================================

    function test_setMaintainer() public {
        address next = makeAddr("next");
        vm.expectEmit(true, true, false, false);
        emit MaintainerUpdated(maintainer, next);
        vm.prank(maintainer);
        k.setMaintainer(next);
        assertEq(k.maintainer(), next);

        vm.prank(alice);
        vm.expectRevert(KodylAbi.NotAuthorized.selector);
        k.setMaintainer(alice);

        vm.prank(next);
        vm.expectRevert(abi.encodeWithSelector(KodylAbi.InvalidEventParameters.selector, "Zero address"));
        k.setMaintainer(address(0));

        vm.prank(next);
        vm.expectRevert(abi.encodeWithSelector(KodylAbi.InvalidEventParameters.selector, "Same maintainer"));
        k.setMaintainer(next);
    }

    function test_setMetadataURI() public {
        uint256 eid = _create();
        vm.expectEmit(true, false, false, true);
        emit MetadataUpdated(eid, "ipfs://new");
        vm.prank(organizer);
        k.setMetadataURI(eid, "ipfs://new");
        assertEq(k.metadataURI(eid), "ipfs://new");

        vm.prank(alice);
        vm.expectRevert(KodylAbi.NotOrganizer.selector);
        k.setMetadataURI(eid, "ipfs://evil");
    }

    function test_setMetadataURI_anyState() public {
        // Deliberately state-independent: the organizer can fix metadata at
        // any point in the lifecycle, including after cancellation.
        uint256 a = _create();
        vm.warp(START_TS + 1);
        uint256 b = _createAs(organizer, 0);
        vm.prank(organizer);
        k.cancelEvent(b);

        _toActive();
        vm.prank(organizer);
        k.setMetadataURI(a, "ipfs://active");
        assertEq(k.metadataURI(a), "ipfs://active");

        vm.prank(organizer);
        k.setMetadataURI(b, "ipfs://cancelled");
        assertEq(k.metadataURI(b), "ipfs://cancelled");

        _toSettled();
        vm.prank(organizer);
        k.setMetadataURI(a, "ipfs://settled");
        assertEq(k.metadataURI(a), "ipfs://settled");
    }

    function test_constants() public view {
        assertEq(k.MAX_BATCH_SIZE(), 100);
        assertEq(k.DUST_CLAIM_TIMEOUT(), 30 days);
        assertEq(k.MIN_CANCELLATION_BUFFER(), 2 hours);
    }

    // ==================================================================
    // full multi-event integration
    // ==================================================================

    function test_integration_twoOverlappingEvents() public {
        uint256 a = _create();
        vm.warp(START_TS + 1);
        uint256 b = _createAs(carol, 0);

        _register(a, alice);
        _register(a, bob);
        _register(b, alice);
        assertEq(k.totalHeld(), 3 * DEPOSIT);

        _toActive();
        vm.prank(organizer);
        k.checkIn(a, alice); // bob no-shows event a
        vm.prank(carol);
        k.checkIn(b, alice);

        _toSettled();
        vm.startPrank(alice);
        k.claim(a); // deposit + bob's forfeit
        k.claim(b); // deposit only
        vm.stopPrank();
        assertEq(alice.balance, 3 * DEPOSIT);

        assertEq(k.held(a), 0);
        assertEq(k.held(b), 0);
        assertEq(k.totalHeld(), 0);
        assertEq(address(k).balance, 0);
    }
}
