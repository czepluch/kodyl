// SPDX-License-Identifier: MIT
pragma solidity ^0.8.33;

import {Test} from "forge-std/Test.sol";
import {CoreDeploy} from "./CoreDeploy.sol";
import {IKodylEvent} from "../../src/interfaces/IKodylEvent.sol";
import {IKodylFactory} from "../../src/interfaces/IKodylFactory.sol";

interface ICoreFactoryV2 {
    function maintainer() external view returns (address);
    function stencil() external view returns (address);
    function eventCount() external view returns (uint256);
    function events(uint256 i) external view returns (address);
    function isKodylEvent(address a) external view returns (bool);
    function createEvent(
        uint256 depositAmount,
        uint256 cancellationDeadline,
        uint256 eventStart,
        uint256 eventEnd,
        uint256 disputePeriod,
        uint256 maxAttendees,
        string calldata metadataURI
    ) external returns (address);
}

/// @notice M10 research-spike gate: the stencil-based createEvent. The stencil
///         is a contract whose runtime code IS KodylEvent's initcode, deployed
///         with the 13-byte returner prefix; KodylFactoryV2 then
///         extcodecopies it, appends abi.encoded args, and CREATE2s real
///         events entirely on-chain.
contract CoreKodylFactoryV2Test is Test {
    event EventCreated(
        address indexed eventContract,
        address indexed organizer,
        uint256 depositAmount,
        uint256 eventStart,
        uint256 eventEnd
    );

    uint256 internal constant START_TS = 1_700_000_000;
    uint256 internal constant DEPOSIT = 1 ether;

    address internal maintainer = makeAddr("maintainer");
    address internal organizer = makeAddr("organizer");
    address internal alice = makeAddr("alice");
    address internal bob = makeAddr("bob");

    ICoreFactoryV2 internal factory;
    uint256 internal eventStart;
    uint256 internal eventEnd;

    function _deployStencil() internal returns (address s) {
        // PUSH1 0x0d CODESIZE SUB DUP1 PUSH1 0x0d PUSH1 0x00 CODECOPY
        // PUSH1 0x00 RETURN - returns everything after the 13-byte prefix as
        // the deployed runtime code.
        bytes memory code = bytes.concat(hex"600d380380600d6000396000f3", CoreDeploy.initcode("KodylEvent"));
        assembly ("memory-safe") {
            s := create(0, add(code, 0x20), mload(code))
        }
        require(s != address(0), "stencil deploy failed");
    }

    function setUp() public {
        vm.warp(START_TS);
        address stencil = _deployStencil();
        factory = ICoreFactoryV2(CoreDeploy.deploy("KodylFactoryV2", abi.encode(maintainer, stencil)));
        eventStart = START_TS + 30 days;
        eventEnd = eventStart + 1 days;
    }

    function _create() internal returns (address) {
        vm.prank(organizer);
        return factory.createEvent(DEPOSIT, eventStart - 7 days, eventStart, eventEnd, 1 days, 0, "ipfs://meta");
    }

    function test_createEvent_deploysAndTracks() public {
        vm.expectEmit(false, true, false, true);
        emit EventCreated(address(0), organizer, DEPOSIT, eventStart, eventEnd);
        address evt = _create();

        assertGt(evt.code.length, 0, "no code at created address");
        assertEq(factory.eventCount(), 1);
        assertEq(factory.events(0), evt);
        assertTrue(factory.isKodylEvent(evt));

        IKodylEvent ev = IKodylEvent(evt);
        assertEq(ev.factory(), address(factory));
        assertEq(ev.organizer(), organizer);
        assertEq(ev.depositAmount(), DEPOSIT);
        assertEq(ev.eventStart(), eventStart);
        assertEq(ev.metadataURI(), "ipfs://meta");
        assertEq(uint256(ev.getState()), uint256(IKodylEvent.State.Registration));
    }

    function test_createEvent_uniqueAddresses() public {
        address a = _create();
        vm.warp(START_TS + 1); // salt includes block.timestamp
        address b = _create();
        assertTrue(a != b);
        assertEq(factory.eventCount(), 2);
    }

    function test_createEvent_validationFires() public {
        vm.prank(organizer);
        vm.expectRevert(abi.encodeWithSelector(IKodylFactory.InvalidEventParameters.selector, "Deposit must be > 0"));
        factory.createEvent(0, eventStart - 7 days, eventStart, eventEnd, 1 days, 0, "ipfs://meta");
    }

    /// @notice Full protocol round-trip on an event the factory deployed
    ///         on-chain: register, check in, settle, claim with reward, and
    ///         dust swept to the maintainer read from THIS factory.
    function test_createEvent_fullLifecycle() public {
        IKodylEvent ev = IKodylEvent(_create());

        vm.deal(alice, DEPOSIT);
        vm.prank(alice);
        ev.register{value: DEPOSIT}();
        vm.deal(bob, DEPOSIT);
        vm.prank(bob);
        ev.register{value: DEPOSIT}();

        vm.warp(eventStart);
        vm.prank(organizer);
        ev.checkIn(alice); // bob is a no-show

        vm.warp(eventEnd + 1 days + 1);
        assertEq(ev.rewardPerAttendee(), DEPOSIT); // bob's deposit, one claimant

        uint256 balBefore = alice.balance;
        vm.prank(alice);
        ev.claim();
        assertEq(alice.balance, balBefore + 2 * DEPOSIT);
        assertEq(address(ev).balance, 0);
    }
}
