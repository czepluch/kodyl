// SPDX-License-Identifier: MIT
pragma solidity ^0.8.33;

import {Test} from "forge-std/Test.sol";
import {CoreDeploy} from "./CoreDeploy.sol";
import {IKodylFactory} from "../../src/interfaces/IKodylFactory.sol";

/// @notice Registry surface of the ported factory. createEvent is replaced by
///         validateEventParameters + registerEvent (deviation 1), so the
///         factory oracle tests are mirrored here against that API; the
///         validation reverts and setMaintainer behavior assert the exact
///         bytes the Solidity original produces.
interface ICoreFactory {
    function maintainer() external view returns (address);
    function eventCount() external view returns (uint256);
    function events(uint256 i) external view returns (address);
    function isKodylEvent(address a) external view returns (bool);
    function MIN_CANCELLATION_BUFFER() external view returns (uint256);
    function VERSION() external view returns (string memory);
    function getAllEvents() external view returns (address[] memory);
    function validateEventParameters(uint256, uint256, uint256, uint256, uint256) external;
    function registerEvent(address evt) external;
    function setMaintainer(address newMaintainer) external;
}

contract CoreKodylFactoryTest is Test {
    error EventAlreadyRegistered();

    event EventCreated(
        address indexed eventContract,
        address indexed organizer,
        uint256 depositAmount,
        uint256 eventStart,
        uint256 eventEnd
    );
    event MaintainerUpdated(address indexed oldMaintainer, address indexed newMaintainer);

    uint256 internal constant START_TS = 1_700_000_000;
    uint256 internal constant DEPOSIT = 1 ether;

    address internal maintainer = makeAddr("maintainer");
    address internal organizer = makeAddr("organizer");
    address internal alice = makeAddr("alice");

    ICoreFactory internal factory;
    uint256 internal eventStart;
    uint256 internal eventEnd;

    function setUp() public {
        vm.warp(START_TS);
        factory = ICoreFactory(CoreDeploy.deploy("KodylFactory", abi.encode(maintainer)));
        eventStart = START_TS + 30 days;
        eventEnd = eventStart + 1 days;
    }

    function _validate(uint256 cancellationDeadline) internal {
        factory.validateEventParameters(DEPOSIT, cancellationDeadline, eventStart, eventEnd, 1 days);
    }

    function _deployEvent() internal returns (address) {
        return CoreDeploy.deploy(
            "KodylEvent",
            abi.encode(
                address(factory),
                organizer,
                DEPOSIT,
                eventStart - 7 days,
                eventStart,
                eventEnd,
                uint256(1 days),
                uint256(0),
                "ipfs://meta"
            )
        );
    }

    // ---- constructor / maintainer ----

    function test_constructor_setsMaintainer() public view {
        assertEq(factory.maintainer(), maintainer);
        assertEq(factory.eventCount(), 0);
    }

    function test_constructor_revertsOnZeroMaintainer() public {
        // create() reverts inside the constructor; the payload is not
        // observable through CREATE, so failure alone is asserted here. The
        // byte-exact "Zero address" payload is pinned via setMaintainer below.
        assertEq(CoreDeploy.tryDeploy("KodylFactory", abi.encode(address(0))), address(0));
    }

    function test_setMaintainer_onlyMaintainer() public {
        address next = makeAddr("next");
        vm.expectEmit(true, true, false, false);
        emit MaintainerUpdated(maintainer, next);
        vm.prank(maintainer);
        factory.setMaintainer(next);
        assertEq(factory.maintainer(), next);
    }

    function test_setMaintainer_revertsForNonMaintainer() public {
        vm.prank(alice);
        vm.expectRevert(IKodylFactory.NotAuthorized.selector);
        factory.setMaintainer(alice);
    }

    function test_setMaintainer_revertsOnZeroAddress() public {
        vm.prank(maintainer);
        vm.expectRevert(abi.encodeWithSelector(IKodylFactory.InvalidEventParameters.selector, "Zero address"));
        factory.setMaintainer(address(0));
    }

    function test_setMaintainer_revertsOnSameMaintainer() public {
        vm.prank(maintainer);
        vm.expectRevert(abi.encodeWithSelector(IKodylFactory.InvalidEventParameters.selector, "Same maintainer"));
        factory.setMaintainer(maintainer);
    }

    // ---- constants ----

    function test_constants() public view {
        assertEq(factory.MIN_CANCELLATION_BUFFER(), 2 hours);
        assertEq(factory.VERSION(), "1.0.0");
    }

    // ---- parameter validation (mirrors the createEvent validation tests) ----

    function test_validate_revertsOnZeroDeposit() public {
        vm.expectRevert(abi.encodeWithSelector(IKodylFactory.InvalidEventParameters.selector, "Deposit must be > 0"));
        factory.validateEventParameters(0, eventStart - 3 days, eventStart, eventEnd, 1 days);
    }

    function test_validate_revertsWhenStartNotFuture() public {
        vm.expectRevert(
            abi.encodeWithSelector(IKodylFactory.InvalidEventParameters.selector, "Event must start in future")
        );
        factory.validateEventParameters(DEPOSIT, START_TS - 1, START_TS, eventEnd, 1 days);
    }

    function test_validate_revertsWhenEndBeforeStart() public {
        vm.expectRevert(
            abi.encodeWithSelector(IKodylFactory.InvalidEventParameters.selector, "Event end must be after start")
        );
        factory.validateEventParameters(DEPOSIT, eventStart - 3 days, eventStart, eventStart, 1 days);
    }

    function test_validate_revertsWhenDeadlineNotFuture() public {
        // Two-word reason string (39 bytes) - pins revertStr2 byte-exactness.
        vm.warp(eventStart - 1 days);
        vm.expectRevert(
            abi.encodeWithSelector(
                IKodylFactory.InvalidEventParameters.selector, "Cancellation deadline must be in future"
            )
        );
        factory.validateEventParameters(DEPOSIT, eventStart - 3 days, eventStart, eventEnd, 1 days);
    }

    function test_validate_revertsWhenDisputeTooShort() public {
        vm.expectRevert(
            abi.encodeWithSelector(IKodylFactory.InvalidEventParameters.selector, "Dispute period too short")
        );
        factory.validateEventParameters(DEPOSIT, eventStart - 3 days, eventStart, eventEnd, 59 minutes);
    }

    function test_validate_revertsWhenDisputeTooLong() public {
        vm.expectRevert(
            abi.encodeWithSelector(IKodylFactory.InvalidEventParameters.selector, "Dispute period too long")
        );
        factory.validateEventParameters(DEPOSIT, eventStart - 3 days, eventStart, eventEnd, 31 days);
    }

    // ---- cancellation-deadline boundary (post bug-fix semantics) ----

    function test_specCompliantDeadlineAccepted() public {
        _validate(eventStart - 7 days); // must not revert
    }

    function test_deadlineExactly2hBeforeAccepted() public {
        _validate(eventStart - 2 hours); // boundary inclusive
    }

    function test_deadlineTooCloseRejected() public {
        vm.expectRevert(
            abi.encodeWithSelector(IKodylFactory.InvalidEventParameters.selector, "Cancellation deadline too late")
        );
        _validate(eventStart - 1 hours);
    }

    function test_deadlineAfterStartRejected() public {
        vm.expectRevert(
            abi.encodeWithSelector(IKodylFactory.InvalidEventParameters.selector, "Cancellation deadline too late")
        );
        _validate(eventStart + 12 hours);
    }

    // ---- registry (replaces deploysAndTracks) ----

    function test_registerEvent_tracksAndEmits() public {
        address evt = _deployEvent();

        vm.expectEmit(true, true, false, true);
        emit EventCreated(evt, organizer, DEPOSIT, eventStart, eventEnd);
        factory.registerEvent(evt);

        assertEq(factory.eventCount(), 1);
        assertEq(factory.events(0), evt);
        assertTrue(factory.isKodylEvent(evt));
        address[] memory all = factory.getAllEvents();
        assertEq(all.length, 1);
        assertEq(all[0], evt);
    }

    function test_registerEvent_revertsOnDoubleRegistration() public {
        address evt = _deployEvent();
        factory.registerEvent(evt);
        vm.expectRevert(EventAlreadyRegistered.selector);
        factory.registerEvent(evt);
    }

    function test_registerEvent_multipleTracked() public {
        address a = _deployEvent();
        address b = _deployEvent();
        factory.registerEvent(a);
        factory.registerEvent(b);
        assertEq(factory.eventCount(), 2);
        assertEq(factory.events(1), b);
        assertEq(factory.getAllEvents().length, 2);
    }
}
