// SPDX-License-Identifier: MIT
pragma solidity ^0.8.33;

import {KodylEventTest} from "../unit/KodylEvent.t.sol";
import {KodylEvent} from "../../src/KodylEvent.sol";
import {CoreDeploy} from "./CoreDeploy.sol";

/// @notice The verification spine of the Core Solidity port: re-runs the ENTIRE
///         KodylEvent oracle suite against the bytecode compiled from
///         core/KodylEvent.solc. Only the deploy helper changes; every assert,
///         expectEmit, and expectRevert byte-comparison is inherited unchanged.
contract CoreKodylEventTest is KodylEventTest {
    function _deploy(uint256 maxAttendees) internal override returns (KodylEvent) {
        return KodylEvent(
            payable(
                CoreDeploy.deploy(
                    "KodylEvent",
                    abi.encode(
                        address(factory),
                        organizer,
                        DEPOSIT,
                        cancellationDeadline,
                        eventStart,
                        eventEnd,
                        disputePeriod,
                        maxAttendees,
                        "ipfs://meta"
                    )
                )
            )
        );
    }
}
