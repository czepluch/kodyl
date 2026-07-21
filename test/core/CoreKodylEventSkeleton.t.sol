// SPDX-License-Identifier: MIT
pragma solidity ^0.8.33;

import {Test} from "forge-std/Test.sol";
import {CoreDeploy} from "./CoreDeploy.sol";
import {IKodylEvent} from "../../src/interfaces/IKodylEvent.sol";

/// @notice M1 gate: constructor-arg delivery and every scalar/string/bool
///         getter of the ported KodylEvent, read through the Solidity interface
///         (proving selector + return-encoding compatibility).
contract CoreKodylEventSkeletonTest is Test {
    uint256 internal constant START_TS = 1_700_000_000;

    function test_skeleton_ctor_and_getters() public {
        address factory = makeAddr("factory");
        address organizer = makeAddr("organizer");
        uint256 eventStart = START_TS + 30 days;

        address e = CoreDeploy.deploy(
            "KodylEvent",
            abi.encode(
                factory,
                organizer,
                uint256(1 ether),
                eventStart - 7 days,
                eventStart,
                eventStart + 1 days,
                uint256(1 days),
                uint256(0),
                "ipfs://meta"
            )
        );

        IKodylEvent ev = IKodylEvent(e);
        assertEq(ev.factory(), factory);
        assertEq(ev.organizer(), organizer);
        assertEq(ev.depositAmount(), 1 ether);
        assertEq(ev.cancellationDeadline(), eventStart - 7 days);
        assertEq(ev.eventStart(), eventStart);
        assertEq(ev.eventEnd(), eventStart + 1 days);
        assertEq(ev.disputePeriod(), 1 days);
        assertEq(ev.maxAttendees(), 0);
        assertEq(ev.metadataURI(), "ipfs://meta");
        assertEq(ev.cancelled(), false);
        assertEq(ev.registeredCount(), 0);
        assertEq(ev.checkedInCount(), 0);
        assertEq(ev.claimedCount(), 0);

        (bool ok, bytes memory ret) = e.staticcall(abi.encodeWithSignature("MAX_BATCH_SIZE()"));
        assertTrue(ok);
        assertEq(abi.decode(ret, (uint256)), 100);
        (ok, ret) = e.staticcall(abi.encodeWithSignature("DUST_CLAIM_TIMEOUT()"));
        assertTrue(ok);
        assertEq(abi.decode(ret, (uint256)), 30 days);
    }
}
