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
    event OperatorSet(uint256 indexed eventId, address indexed operator, bool enabled);

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
    // proof-based check-in (EIP-712 Ticket + Presence)
    // ==================================================================
    // Digests are computed HERE with plain Solidity (abi.encode + the 0x1901
    // prefix), independently of the contract's hand-rolled concat hashing - a
    // divergence between the two implementations surfaces as
    // TicketSignerMismatch, so every green test cross-checks the encoding.

    bytes32 internal constant DOMAIN_TYPEHASH =
        keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)");
    bytes32 internal constant TICKET_TYPEHASH = keccak256("Ticket(uint256 eventId)");
    bytes32 internal constant PRESENCE_TYPEHASH =
        keccak256("Presence(uint256 eventId,address attendee,uint256 validUntil)");
    uint256 internal constant SECP256K1_N =
        0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141;

    function _domain712(address verifying, uint256 chainId) internal pure returns (bytes32) {
        return keccak256(
            abi.encode(DOMAIN_TYPEHASH, keccak256("Kodyl"), keccak256("1"), chainId, verifying)
        );
    }

    function _digest712(bytes32 structHash) internal view returns (bytes32) {
        return keccak256(
            abi.encodePacked(hex"1901", _domain712(address(k), block.chainid), structHash)
        );
    }

    function _signTicket(uint256 pk, uint256 eid) internal view returns (bytes memory) {
        (uint8 v, bytes32 r, bytes32 s) =
            vm.sign(pk, _digest712(keccak256(abi.encode(TICKET_TYPEHASH, eid))));
        return abi.encodePacked(r, s, v);
    }

    function _signPresence(uint256 pk, uint256 eid, address attendee, uint256 validUntil)
        internal
        view
        returns (bytes memory)
    {
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(
            pk, _digest712(keccak256(abi.encode(PRESENCE_TYPEHASH, eid, attendee, validUntil)))
        );
        return abi.encodePacked(r, s, v);
    }

    /// Keyed actors (the fixture addresses have no known keys), one event
    /// organized by a signing organizer, one registered signing attendee,
    /// warped to Active.
    function _proofSetup()
        internal
        returns (uint256 eid, address org, uint256 orgPk, address dana, uint256 danaPk)
    {
        (org, orgPk) = makeAddrAndKey("orgSigner");
        (dana, danaPk) = makeAddrAndKey("dana");
        eid = _createAs(org, 0);
        _register(eid, dana);
        _toActive();
    }

    function test_proofCheckIn_happyPath_submittedByAnyone() public {
        (uint256 eid, , uint256 orgPk, address dana, uint256 danaPk) = _proofSetup();
        uint256 validUntil = block.timestamp + 24 hours;

        vm.expectEmit(true, true, false, true);
        emit CheckedIn(eid, dana);
        vm.prank(makeAddr("relayer"));
        k.checkInWithProof(
            eid, dana, validUntil, _signTicket(danaPk, eid), _signPresence(orgPk, eid, dana, validUntil)
        );

        assertEq(k.attendees(eid, dana), CHECKED_IN);
        assertEq(k.checkedInCount(eid), 1);
    }

    function test_proofCheckIn_replayIsSilentNoOp() public {
        (uint256 eid, , uint256 orgPk, address dana, uint256 danaPk) = _proofSetup();
        uint256 validUntil = block.timestamp + 24 hours;
        bytes memory t = _signTicket(danaPk, eid);
        bytes memory p = _signPresence(orgPk, eid, dana, validUntil);

        k.checkInWithProof(eid, dana, validUntil, t, p);
        assertEq(k.checkedInCount(eid), 1);

        // Same pair again: checkInInner sees CheckedIn and skips - no revert,
        // no double count.
        k.checkInWithProof(eid, dana, validUntil, t, p);
        assertEq(k.checkedInCount(eid), 1);
        assertEq(k.attendees(eid, dana), CHECKED_IN);
    }

    function test_proofCheckIn_expiryBoundary() public {
        (uint256 eid, , uint256 orgPk, address dana, uint256 danaPk) = _proofSetup();
        (address erin, uint256 erinPk) = makeAddrAndKey("erin");
        // Second attendee registered pre-Active (the fixture warps before
        // this test body runs, so rewind to register, then return).
        vm.warp(START_TS);
        _register(eid, erin);
        _toActive();

        uint256 validUntil = block.timestamp + 24 hours;
        bytes memory tDana = _signTicket(danaPk, eid);
        bytes memory pDana = _signPresence(orgPk, eid, dana, validUntil);
        bytes memory tErin = _signTicket(erinPk, eid);
        bytes memory pErin = _signPresence(orgPk, eid, erin, validUntil);

        // t == validUntil: inclusive boundary, still submits (the check-in
        // window is also still open: validUntil == eventEnd here).
        vm.warp(validUntil);
        k.checkInWithProof(eid, dana, validUntil, tDana, pDana);
        assertEq(k.attendees(eid, dana), CHECKED_IN);

        // t == validUntil + 1 lands in Dispute (window open), so the revert
        // is ProofExpired, not the state gate.
        vm.warp(validUntil + 1);
        vm.expectRevert(KodylAbi.ProofExpired.selector);
        k.checkInWithProof(eid, erin, validUntil, tErin, pErin);
    }

    function test_proofCheckIn_succeedsDuringDispute() public {
        (uint256 eid, , uint256 orgPk, address dana, uint256 danaPk) = _proofSetup();
        // Window admits Active AND Dispute; the feature's whole point is
        // submission after the doors, inside the 24h settlement window.
        uint256 validUntil = eventEnd + 24 hours;
        vm.warp(eventEnd + 2 hours); // Dispute (past eventEnd, before eventEnd+disputePeriod)
        assertEq(k.getState(eid), ST_DISPUTE);

        k.checkInWithProof(
            eid, dana, validUntil, _signTicket(danaPk, eid), _signPresence(orgPk, eid, dana, validUntil)
        );
        assertEq(k.attendees(eid, dana), CHECKED_IN);
    }

    function test_proofBatch_succeedsAtDisputeBackEdge() public {
        (uint256 eid, address org, uint256 orgPk, address dana, uint256 danaPk) = _proofSetup();
        // The inclusive back edge of the window: eventEnd + disputePeriod is
        // still Dispute (test_getState/test_checkIn_windowBackEdge pin this).
        uint256 validUntil = eventEnd + disputePeriod + 24 hours;
        vm.warp(eventEnd + disputePeriod);
        assertEq(k.getState(eid), ST_DISPUTE);

        address[] memory who = new address[](1);
        who[0] = dana;
        uint256[] memory untils = new uint256[](1);
        untils[0] = validUntil;
        bytes[] memory tickets = new bytes[](1);
        tickets[0] = _signTicket(danaPk, eid);
        bytes[] memory presences = new bytes[](1);
        presences[0] = _signPresence(orgPk, eid, dana, validUntil);

        vm.prank(org);
        k.checkInBatchWithProofs(eid, who, untils, tickets, presences);
        assertEq(k.attendees(eid, dana), CHECKED_IN);
    }

    function test_proofCheckIn_invalidRecoveryDoesNotReturnStaleSigner() public {
        // Regression for the std ecrecover scratch-reuse defect: v outside
        // {27,28} makes the precompile return empty, and without pre-zeroing
        // the scratch slot ecrecover would hand back a stale address. The
        // recoverStrict shim forces the intended ECRecoverFailed instead of a
        // spurious signer match. Assert the failure surfaces (never a silent
        // success or a stale-address TicketSignerMismatch that hides it).
        (uint256 eid, , uint256 orgPk, address dana, uint256 danaPk) = _proofSetup();
        uint256 validUntil = block.timestamp + 24 hours;
        bytes memory presence = _signPresence(orgPk, eid, dana, validUntil);

        // Ticket with v = 0 (invalid recovery id). Low-s so the malleability
        // guard passes and the precompile is actually reached.
        bytes memory ticketV0;
        {
            (, bytes32 r, bytes32 s) =
                vm.sign(danaPk, _digest712(keccak256(abi.encode(TICKET_TYPEHASH, eid))));
            ticketV0 = abi.encodePacked(r, s, uint8(0));
        }
        vm.expectRevert(KodylAbi.ECRecoverFailed.selector);
        k.checkInWithProof(eid, dana, validUntil, ticketV0, presence);
        assertEq(k.attendees(eid, dana), REGISTERED);
    }

    function test_proofCheckIn_notRegisteredIsSilentSkip() public {
        // A never-registered address with fully valid signatures: checkInInner
        // sees status None and skips silently (no revert, no count), mirroring
        // the direct checkIn tolerance.
        (uint256 eid, , uint256 orgPk, , ) = _proofSetup();
        (address mallory, uint256 malloryPk) = makeAddrAndKey("mallory");
        uint256 validUntil = block.timestamp + 24 hours;

        k.checkInWithProof(
            eid, mallory, validUntil,
            _signTicket(malloryPk, eid), _signPresence(orgPk, eid, mallory, validUntil)
        );
        assertEq(k.attendees(eid, mallory), NONE);
        assertEq(k.checkedInCount(eid), 0);
    }

    function test_proofCheckIn_ticketForOtherEventReverts() public {
        // Ticket correctly signed by dana but for a DIFFERENT event id:
        // hashTicket binds the eid, so recovery against event `eid` yields a
        // different signer. Proves cross-event ticket replay is rejected.
        (uint256 eid, address org, uint256 orgPk, address dana, uint256 danaPk) = _proofSetup();
        vm.warp(START_TS + 1);
        uint256 other = _createAs(org, 0);
        vm.warp(eventStart); // back to Active for eid
        uint256 validUntil = block.timestamp + 24 hours;

        vm.expectRevert(KodylAbi.TicketSignerMismatch.selector);
        k.checkInWithProof(
            eid, dana, validUntil,
            _signTicket(danaPk, other), _signPresence(orgPk, eid, dana, validUntil)
        );
        assertEq(k.attendees(eid, dana), REGISTERED);
    }

    function test_proofBatch_oneBumpCheckedInPerCall() public {
        // The Counters product (registered, checkedIn, claimed, held) is one
        // 4-slot group; the plan mandates ONE bumpCheckedIn write per external
        // call, not per attendee. Record storage writes and assert the group's
        // base slot is written exactly once for a two-flip batch.
        (uint256 eid, address org, uint256 orgPk, address dana, uint256 danaPk) = _proofSetup();
        (address erin, uint256 erinPk) = makeAddrAndKey("erin");
        vm.warp(START_TS);
        _register(eid, erin);
        _toActive();
        uint256 validUntil = block.timestamp + 24 hours;

        address[] memory who = new address[](2);
        who[0] = dana;
        who[1] = erin;
        uint256[] memory untils = new uint256[](2);
        untils[0] = validUntil;
        untils[1] = validUntil;
        bytes[] memory tickets = new bytes[](2);
        tickets[0] = _signTicket(danaPk, eid);
        tickets[1] = _signTicket(erinPk, eid);
        bytes[] memory presences = new bytes[](2);
        presences[0] = _signPresence(orgPk, eid, dana, validUntil);
        presences[1] = _signPresence(orgPk, eid, erin, validUntil);

        vm.record();
        vm.prank(org);
        k.checkInBatchWithProofs(eid, who, untils, tickets, presences);
        (, bytes32[] memory writes) = vm.accesses(address(k));

        assertEq(k.checkedInCount(eid), 2, "both should have flipped");
        // One bumpCheckedIn per call, not per attendee: checkInInner writes a
        // distinct statusM slot per flip, and the single bump writes the
        // Counters group once - so no storage slot is written more than once.
        // A per-entry bump would re-store the Counters slot(s) on each flip,
        // producing a duplicate. Slot-layout-agnostic: it needs no knowledge
        // of solcore's mapping-hash order, only the no-duplicate invariant.
        for (uint256 i = 0; i < writes.length; i++) {
            for (uint256 j = i + 1; j < writes.length; j++) {
                assertTrue(writes[i] != writes[j], "a storage slot was written more than once");
            }
        }
    }

    function test_proofBatch_expiredEntryAtNonZeroIndexReverts() public {
        // Pins per-entry validUntil indexing: a mutant reading validUntils[0]
        // for every element would accept an expired entry at index 1. Entry 0
        // has an open window, entry 1 is expired; the batch must revert.
        (uint256 eid, address org, uint256 orgPk, address dana, uint256 danaPk) = _proofSetup();
        (address erin, uint256 erinPk) = makeAddrAndKey("erin");
        vm.warp(START_TS);
        _register(eid, erin);
        _toActive();

        uint256 openUntil = eventEnd + disputePeriod;   // still valid now
        uint256 expiredUntil = block.timestamp - 1;      // already past

        address[] memory who = new address[](2);
        who[0] = dana;
        who[1] = erin;
        uint256[] memory untils = new uint256[](2);
        untils[0] = openUntil;
        untils[1] = expiredUntil;
        bytes[] memory tickets = new bytes[](2);
        tickets[0] = _signTicket(danaPk, eid);
        tickets[1] = _signTicket(erinPk, eid);
        bytes[] memory presences = new bytes[](2);
        presences[0] = _signPresence(orgPk, eid, dana, openUntil);
        presences[1] = _signPresence(orgPk, eid, erin, expiredUntil);

        vm.prank(org);
        vm.expectRevert(KodylAbi.ProofExpired.selector);
        k.checkInBatchWithProofs(eid, who, untils, tickets, presences);
        assertEq(k.checkedInCount(eid), 0);
    }

    function test_proofCheckIn_wrongTicketSignerReverts() public {
        (uint256 eid, , uint256 orgPk, address dana, ) = _proofSetup();
        (, uint256 erinPk) = makeAddrAndKey("erin");
        uint256 validUntil = block.timestamp + 24 hours;

        // Ticket signed by erin's key but claiming dana: the recovered signer
        // is erin, not the claimed attendee.
        vm.expectRevert(KodylAbi.TicketSignerMismatch.selector);
        k.checkInWithProof(
            eid, dana, validUntil, _signTicket(erinPk, eid), _signPresence(orgPk, eid, dana, validUntil)
        );
        assertEq(k.attendees(eid, dana), REGISTERED);
    }

    function test_proofCheckIn_unauthorizedPresenceReverts() public {
        (uint256 eid, , uint256 orgPk, address dana, uint256 danaPk) = _proofSetup();
        (address erin, uint256 erinPk) = makeAddrAndKey("erin");
        uint256 validUntil = block.timestamp + 24 hours;

        // Presence self-signed by the attendee: valid signature, wrong signer.
        vm.expectRevert(KodylAbi.PresenceSignerUnauthorized.selector);
        k.checkInWithProof(
            eid, dana, validUntil, _signTicket(danaPk, eid), _signPresence(danaPk, eid, dana, validUntil)
        );

        // Presence the organizer signed for DANA replayed for erin: the
        // contract hashes (eid, erin, validUntil), so the recovered signer is
        // no longer the organizer - the attestation is bound to one body.
        vm.warp(START_TS);
        _register(eid, erin);
        _toActive();
        vm.expectRevert(KodylAbi.PresenceSignerUnauthorized.selector);
        k.checkInWithProof(
            eid, erin, validUntil, _signTicket(erinPk, eid), _signPresence(orgPk, eid, dana, validUntil)
        );
    }

    function test_proofCheckIn_operatorPresence() public {
        (uint256 eid, address org, , address dana, uint256 danaPk) = _proofSetup();
        (address doorOp, uint256 doorPk) = makeAddrAndKey("doorOp");
        uint256 validUntil = block.timestamp + 24 hours;

        vm.expectEmit(true, true, false, true);
        emit OperatorSet(eid, doorOp, true);
        vm.prank(org);
        k.addOperator(eid, doorOp);
        assertTrue(k.isOperator(eid, doorOp));

        // Operator-countersigned presence checks dana in.
        k.checkInWithProof(
            eid, dana, validUntil, _signTicket(danaPk, eid), _signPresence(doorPk, eid, dana, validUntil)
        );
        assertEq(k.attendees(eid, dana), CHECKED_IN);
    }

    function test_proofCheckIn_revokedOperatorReverts() public {
        (uint256 eid, address org, , address dana, uint256 danaPk) = _proofSetup();
        (address doorOp, uint256 doorPk) = makeAddrAndKey("doorOp");
        uint256 validUntil = block.timestamp + 24 hours;

        vm.prank(org);
        k.addOperator(eid, doorOp);
        vm.expectEmit(true, true, false, true);
        emit OperatorSet(eid, doorOp, false);
        vm.prank(org);
        k.removeOperator(eid, doorOp);
        assertFalse(k.isOperator(eid, doorOp));

        // The revoked operator's attestation no longer authorizes.
        vm.expectRevert(KodylAbi.PresenceSignerUnauthorized.selector);
        k.checkInWithProof(
            eid, dana, validUntil, _signTicket(danaPk, eid), _signPresence(doorPk, eid, dana, validUntil)
        );
    }

    function test_operatorManagement_authMatrix() public {
        uint256 eid = _create();
        vm.prank(alice);
        vm.expectRevert(KodylAbi.NotOrganizer.selector);
        k.addOperator(eid, bob);
        vm.prank(alice);
        vm.expectRevert(KodylAbi.NotOrganizer.selector);
        k.removeOperator(eid, bob);
        vm.expectRevert(KodylAbi.EventNotFound.selector);
        k.addOperator(99, bob);
        vm.expectRevert(KodylAbi.EventNotFound.selector);
        k.removeOperator(99, bob);
        // Zero-tier getter: false for unknown events and unknown operators,
        // never a revert.
        assertFalse(k.isOperator(99, bob));
        assertFalse(k.isOperator(eid, bob));
    }

    function test_proofCheckIn_invalidSignatureLengthReverts() public {
        (uint256 eid, , uint256 orgPk, address dana, uint256 danaPk) = _proofSetup();
        uint256 validUntil = block.timestamp + 24 hours;
        bytes memory good = _signTicket(danaPk, eid);
        bytes memory short64 = new bytes(64);
        bytes memory long66 = abi.encodePacked(good, uint8(0));

        vm.expectRevert(KodylAbi.InvalidSignatureLength.selector);
        k.checkInWithProof(eid, dana, validUntil, short64, _signPresence(orgPk, eid, dana, validUntil));
        vm.expectRevert(KodylAbi.InvalidSignatureLength.selector);
        k.checkInWithProof(eid, dana, validUntil, good, long66);
    }

    function test_proofCheckIn_malleableHighSReverts() public {
        (uint256 eid, , uint256 orgPk, address dana, uint256 danaPk) = _proofSetup();
        uint256 validUntil = block.timestamp + 24 hours;
        bytes memory presence = _signPresence(orgPk, eid, dana, validUntil);

        // Rewrite the valid ticket signature into its high-s twin; the std
        // rejects it before the precompile ever runs.
        bytes memory highS;
        {
            (uint8 v, bytes32 r, bytes32 s) =
                vm.sign(danaPk, _digest712(keccak256(abi.encode(TICKET_TYPEHASH, eid))));
            highS = abi.encodePacked(
                r, bytes32(SECP256K1_N - uint256(s)), v == 27 ? uint8(28) : uint8(27)
            );
        }

        vm.expectRevert(KodylAbi.MalleableSignatureRejected.selector);
        k.checkInWithProof(eid, dana, validUntil, highS, presence);
    }

    function test_proofCheckIn_domainBindingRejectsForeignDigests() public {
        (uint256 eid, , uint256 orgPk, address dana, uint256 danaPk) = _proofSetup();
        uint256 validUntil = block.timestamp + 24 hours;
        bytes32 ticketStruct = keccak256(abi.encode(TICKET_TYPEHASH, eid));
        bytes memory presence = _signPresence(orgPk, eid, dana, validUntil);

        // Signed for another verifying contract: recovery yields some other
        // address, never the attendee.
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(
            danaPk,
            keccak256(
                abi.encodePacked(
                    hex"1901", _domain712(makeAddr("otherContract"), block.chainid), ticketStruct
                )
            )
        );
        vm.expectRevert(KodylAbi.TicketSignerMismatch.selector);
        k.checkInWithProof(eid, dana, validUntil, abi.encodePacked(r, s, v), presence);

        // Signed for another chain id.
        (v, r, s) = vm.sign(
            danaPk,
            keccak256(
                abi.encodePacked(
                    hex"1901", _domain712(address(k), block.chainid + 1), ticketStruct
                )
            )
        );
        vm.expectRevert(KodylAbi.TicketSignerMismatch.selector);
        k.checkInWithProof(eid, dana, validUntil, abi.encodePacked(r, s, v), presence);
    }

    function test_proofCheckIn_stateGates() public {
        (address org, uint256 orgPk) = makeAddrAndKey("orgSigner");
        (address dana, uint256 danaPk) = makeAddrAndKey("dana");
        uint256 eid = _createAs(org, 0);
        _register(eid, dana);
        // A far-future validUntil keeps ProofExpired out of the way: the
        // state gate must fire first in every phase.
        uint256 validUntil = eventEnd + 60 days;
        bytes memory t = _signTicket(danaPk, eid);
        bytes memory p = _signPresence(orgPk, eid, dana, validUntil);

        // Registration phase.
        vm.expectRevert(KodylAbi.CheckInWindowClosed.selector);
        k.checkInWithProof(eid, dana, validUntil, t, p);

        // Settled.
        _toSettled();
        vm.expectRevert(KodylAbi.CheckInWindowClosed.selector);
        k.checkInWithProof(eid, dana, validUntil, t, p);

        // Cancelled event (fresh event, cancelled during Registration).
        vm.warp(START_TS + 1);
        uint256 eid2 = _createAs(org, 0);
        _register(eid2, dana);
        vm.prank(org);
        k.cancelEvent(eid2);
        _toActive();
        vm.expectRevert(KodylAbi.CheckInWindowClosed.selector);
        k.checkInWithProof(
            eid2, dana, validUntil, _signTicket(danaPk, eid2), _signPresence(orgPk, eid2, dana, validUntil)
        );
    }

    function test_proofCheckIn_unknownEventReverts() public {
        vm.expectRevert(KodylAbi.EventNotFound.selector);
        k.checkInWithProof(99, alice, block.timestamp + 1, hex"", hex"");
        vm.expectRevert(KodylAbi.EventNotFound.selector);
        k.checkInBatchWithProofs(
            99, new address[](0), new uint256[](0), new bytes[](0), new bytes[](0)
        );
    }

    function test_proofBatch_happyPath_mixedWithNoOp() public {
        (uint256 eid, address org, uint256 orgPk, address dana, uint256 danaPk) = _proofSetup();
        (address erin, uint256 erinPk) = makeAddrAndKey("erin");
        vm.warp(START_TS);
        _register(eid, erin);
        _toActive();
        uint256 validUntil = block.timestamp + 24 hours;

        // dana is already checked in via the direct organizer path; her batch
        // entry must be a silent no-op while erin's flips.
        vm.prank(org);
        k.checkIn(eid, dana);
        assertEq(k.checkedInCount(eid), 1);

        address[] memory who = new address[](2);
        who[0] = dana;
        who[1] = erin;
        uint256[] memory untils = new uint256[](2);
        untils[0] = validUntil;
        untils[1] = validUntil;
        bytes[] memory tickets = new bytes[](2);
        tickets[0] = _signTicket(danaPk, eid);
        tickets[1] = _signTicket(erinPk, eid);
        bytes[] memory presences = new bytes[](2);
        presences[0] = _signPresence(orgPk, eid, dana, validUntil);
        presences[1] = _signPresence(orgPk, eid, erin, validUntil);

        vm.prank(makeAddr("relayer"));
        k.checkInBatchWithProofs(eid, who, untils, tickets, presences);

        assertEq(k.attendees(eid, dana), CHECKED_IN);
        assertEq(k.attendees(eid, erin), CHECKED_IN);
        assertEq(k.checkedInCount(eid), 2);
    }

    function test_proofBatch_badSignatureRevertsWholeBatch() public {
        (uint256 eid, , uint256 orgPk, address dana, uint256 danaPk) = _proofSetup();
        (address erin, uint256 erinPk) = makeAddrAndKey("erin");
        vm.warp(START_TS);
        _register(eid, erin);
        _toActive();
        uint256 validUntil = block.timestamp + 24 hours;

        address[] memory who = new address[](2);
        who[0] = erin;
        who[1] = dana;
        uint256[] memory untils = new uint256[](2);
        untils[0] = validUntil;
        untils[1] = validUntil;
        bytes[] memory tickets = new bytes[](2);
        tickets[0] = _signTicket(erinPk, eid);
        tickets[1] = _signTicket(erinPk, eid); // wrong key for dana
        bytes[] memory presences = new bytes[](2);
        presences[0] = _signPresence(orgPk, eid, erin, validUntil);
        presences[1] = _signPresence(orgPk, eid, dana, validUntil);

        // A malformed submission reverts atomically: erin's valid entry (index
        // 0, already processed) must not survive.
        vm.expectRevert(KodylAbi.TicketSignerMismatch.selector);
        k.checkInBatchWithProofs(eid, who, untils, tickets, presences);
        assertEq(k.attendees(eid, erin), REGISTERED);
        assertEq(k.attendees(eid, dana), REGISTERED);
        assertEq(k.checkedInCount(eid), 0);
    }

    function test_proofBatch_arrayMismatchReverts() public {
        (uint256 eid, , , , ) = _proofSetup();
        address[] memory who = new address[](2);
        uint256[] memory one = new uint256[](1);
        uint256[] memory two = new uint256[](2);
        bytes[] memory oneB = new bytes[](1);
        bytes[] memory twoB = new bytes[](2);

        vm.expectRevert(KodylAbi.ProofArrayMismatch.selector);
        k.checkInBatchWithProofs(eid, who, one, twoB, twoB);
        vm.expectRevert(KodylAbi.ProofArrayMismatch.selector);
        k.checkInBatchWithProofs(eid, who, two, oneB, twoB);
        vm.expectRevert(KodylAbi.ProofArrayMismatch.selector);
        k.checkInBatchWithProofs(eid, who, two, twoB, oneB);
    }

    function test_proofBatch_capBatchTooLarge() public {
        (uint256 eid, , , , ) = _proofSetup();
        uint256 n = 101;
        address[] memory who = new address[](n);
        uint256[] memory untils = new uint256[](n);
        bytes[] memory sigs = new bytes[](n);

        // Length checks precede the cap, and the cap precedes any signature
        // work, so empty sig payloads never get read.
        vm.expectRevert(abi.encodeWithSelector(KodylAbi.BatchTooLarge.selector, n, 100));
        k.checkInBatchWithProofs(eid, who, untils, sigs, sigs);
    }

    function test_proofBatch_emptyIsNoOp() public {
        (uint256 eid, , , , ) = _proofSetup();
        k.checkInBatchWithProofs(
            eid, new address[](0), new uint256[](0), new bytes[](0), new bytes[](0)
        );
        assertEq(k.checkedInCount(eid), 0);
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
