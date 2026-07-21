// SPDX-License-Identifier: MIT
pragma solidity ^0.8.33;

import {Test} from "forge-std/Test.sol";
import {CoreDeploy} from "./CoreDeploy.sol";
import {IKodylEvent} from "../../src/interfaces/IKodylEvent.sol";

/// @notice M2 gate: timestamp-derived state transitions (mirrors the oracle's
///         test_getState_transitionsOverTime boundaries exactly) and the
///         AttendeeStatus zero-default through the ADT mapping.
contract CoreKodylEventStateTest is Test {
    uint256 internal constant START_TS = 1_700_000_000;

    uint256 internal eventStart;
    uint256 internal eventEnd;
    uint256 internal disputePeriod = 1 days;
    IKodylEvent internal ev;

    function setUp() public {
        vm.warp(START_TS);
        eventStart = START_TS + 30 days;
        eventEnd = eventStart + 1 days;
        ev = IKodylEvent(
            CoreDeploy.deploy(
                "KodylEvent",
                abi.encode(
                    makeAddr("factory"),
                    makeAddr("organizer"),
                    uint256(1 ether),
                    eventStart - 7 days,
                    eventStart,
                    eventEnd,
                    disputePeriod,
                    uint256(0),
                    "ipfs://meta"
                )
            )
        );
    }

    function test_getState_transitionsOverTime() public {
        assertEq(uint256(ev.getState()), uint256(IKodylEvent.State.Registration));
        vm.warp(eventStart);
        assertEq(uint256(ev.getState()), uint256(IKodylEvent.State.Active));
        vm.warp(eventEnd);
        assertEq(uint256(ev.getState()), uint256(IKodylEvent.State.Active)); // inclusive
        vm.warp(eventEnd + 1);
        assertEq(uint256(ev.getState()), uint256(IKodylEvent.State.Dispute));
        vm.warp(eventEnd + disputePeriod);
        assertEq(uint256(ev.getState()), uint256(IKodylEvent.State.Dispute)); // inclusive
        vm.warp(eventEnd + disputePeriod + 1);
        assertEq(uint256(ev.getState()), uint256(IKodylEvent.State.Settled));
    }

    function test_attendees_defaultsToNone() public {
        assertEq(uint256(ev.attendees(makeAddr("nobody"))), uint256(IKodylEvent.AttendeeStatus.None));
    }
}
