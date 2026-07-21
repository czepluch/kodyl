// SPDX-License-Identifier: MIT
pragma solidity ^0.8.33;

import {Test} from "forge-std/Test.sol";
import {KodylFactory} from "../../src/KodylFactory.sol";
import {KodylEvent} from "../../src/KodylEvent.sol";
import {IKodylFactory} from "../../src/interfaces/IKodylFactory.sol";
import {IKodylEvent} from "../../src/interfaces/IKodylEvent.sol";

contract KodylFactoryTest is Test {
    KodylFactory internal factory;

    address internal maintainer = makeAddr("maintainer");
    address internal organizer = makeAddr("organizer");
    address internal alice = makeAddr("alice");

    uint256 internal constant START_TS = 1_700_000_000;
    uint256 internal constant DEPOSIT = 1 ether;

    uint256 internal eventStart;
    uint256 internal eventEnd;

    function setUp() public {
        vm.warp(START_TS);
        factory = new KodylFactory(maintainer);
        eventStart = START_TS + 30 days;
        eventEnd = eventStart + 1 days;
    }

    function _create(uint256 cancellationDeadline) internal returns (address) {
        vm.prank(organizer);
        return factory.createEvent(DEPOSIT, cancellationDeadline, eventStart, eventEnd, 1 days, 0, "ipfs://meta");
    }

    // ======================================================================
    // constructor / maintainer
    // ======================================================================

    function test_constructor_setsMaintainer() public view {
        assertEq(factory.maintainer(), maintainer);
        assertEq(factory.eventCount(), 0);
    }

    function test_constructor_revertsOnZeroMaintainer() public {
        vm.expectRevert(abi.encodeWithSelector(IKodylFactory.InvalidEventParameters.selector, "Zero address"));
        new KodylFactory(address(0));
    }

    function test_setMaintainer_onlyMaintainer() public {
        address next = makeAddr("next");
        vm.prank(maintainer);
        factory.setMaintainer(next);
        assertEq(factory.maintainer(), next);
    }

    function test_setMaintainer_revertsForNonMaintainer() public {
        vm.prank(alice);
        vm.expectRevert(IKodylFactory.NotAuthorized.selector);
        factory.setMaintainer(alice);
    }

    // ======================================================================
    // createEvent - happy path & tracking
    // ======================================================================

    function test_createEvent_deploysAndTracks() public {
        // Spec-compliant deadline: at least 2h before the event.
        address addr = _create(eventStart - 3 days);

        assertEq(factory.eventCount(), 1);
        assertEq(factory.events(0), addr);
        assertTrue(factory.isKodylEvent(addr));

        KodylEvent ev = KodylEvent(payable(addr));
        assertEq(ev.factory(), address(factory));
        assertEq(ev.organizer(), organizer);
        assertEq(ev.depositAmount(), DEPOSIT);
    }

    function test_createEvent_multipleGetUniqueAddresses() public {
        address a = _create(eventStart - 3 days);
        // vary a parameter so the CREATE2 salt differs
        vm.warp(START_TS + 1);
        vm.prank(organizer);
        address b = factory.createEvent(DEPOSIT, eventStart - 3 days, eventStart, eventEnd, 1 days, 0, "ipfs://b");
        assertTrue(a != b);
        assertEq(factory.eventCount(), 2);
    }

    // ======================================================================
    // createEvent - parameter validation
    // ======================================================================

    function test_createEvent_revertsOnZeroDeposit() public {
        vm.prank(organizer);
        vm.expectRevert(abi.encodeWithSelector(IKodylFactory.InvalidEventParameters.selector, "Deposit must be > 0"));
        factory.createEvent(0, eventStart - 1 hours, eventStart, eventEnd, 1 days, 0, "");
    }

    function test_createEvent_revertsWhenStartNotFuture() public {
        vm.prank(organizer);
        vm.expectRevert(
            abi.encodeWithSelector(IKodylFactory.InvalidEventParameters.selector, "Event must start in future")
        );
        factory.createEvent(DEPOSIT, START_TS - 1, START_TS, eventEnd, 1 days, 0, "");
    }

    function test_createEvent_revertsWhenEndBeforeStart() public {
        vm.prank(organizer);
        vm.expectRevert(
            abi.encodeWithSelector(IKodylFactory.InvalidEventParameters.selector, "Event end must be after start")
        );
        factory.createEvent(DEPOSIT, eventStart - 1 hours, eventStart, eventStart, 1 days, 0, "");
    }

    function test_createEvent_revertsWhenDisputeTooShort() public {
        vm.prank(organizer);
        vm.expectRevert(
            abi.encodeWithSelector(IKodylFactory.InvalidEventParameters.selector, "Dispute period too short")
        );
        factory.createEvent(DEPOSIT, eventStart - 3 days, eventStart, eventEnd, 59 minutes, 0, "");
    }

    function test_createEvent_revertsWhenDisputeTooLong() public {
        vm.prank(organizer);
        vm.expectRevert(
            abi.encodeWithSelector(IKodylFactory.InvalidEventParameters.selector, "Dispute period too long")
        );
        factory.createEvent(DEPOSIT, eventStart - 3 days, eventStart, eventEnd, 31 days, 0, "");
    }

    // ======================================================================
    // cancellation-deadline buffer (fixed: at least 2h before, with upper bound)
    // ======================================================================

    /// @notice A spec-compliant deadline (comfortably before the event) is now
    /// accepted. Previously the inverted check rejected it as "too late".
    function test_specCompliantDeadlineAccepted() public {
        address addr = _create(eventStart - 7 days);
        assertTrue(factory.isKodylEvent(addr));
        assertEq(KodylEvent(payable(addr)).cancellationDeadline(), eventStart - 7 days);
    }

    /// @notice The boundary is inclusive: exactly 2h before the event is allowed.
    function test_deadlineExactly2hBeforeAccepted() public {
        address addr = _create(eventStart - 2 hours);
        assertTrue(factory.isKodylEvent(addr));
    }

    /// @notice A deadline less than 2h before the event is rejected (upper bound).
    function test_deadlineTooCloseRejected() public {
        vm.prank(organizer);
        vm.expectRevert(
            abi.encodeWithSelector(IKodylFactory.InvalidEventParameters.selector, "Cancellation deadline too late")
        );
        factory.createEvent(DEPOSIT, eventStart - 1 hours, eventStart, eventEnd, 1 days, 0, "");
    }

    /// @notice A deadline at/after eventStart is now rejected, closing the
    /// mid-event refund that would otherwise defeat no-show forfeiture.
    function test_deadlineAfterStartRejected() public {
        vm.prank(organizer);
        vm.expectRevert(
            abi.encodeWithSelector(IKodylFactory.InvalidEventParameters.selector, "Cancellation deadline too late")
        );
        factory.createEvent(DEPOSIT, eventStart + 12 hours, eventStart, eventEnd, 1 days, 0, "");
    }
}
