// SPDX-License-Identifier: MIT
pragma solidity ^0.8.33;

import {DepositAccountingInvariant} from "../invariant/DepositAccounting.t.sol";
import {KodylEvent} from "../../src/KodylEvent.sol";
import {CoreDeploy} from "./CoreDeploy.sol";

/// @notice Re-runs the deposit-accounting invariant fuzz (256 runs x 500 calls)
///         against the Core Solidity bytecode.
contract CoreDepositAccountingInvariant is DepositAccountingInvariant {
    function _deployEvent(uint256 eventStart) internal override returns (KodylEvent) {
        return KodylEvent(
            payable(
                CoreDeploy.deploy(
                    "KodylEvent",
                    abi.encode(
                        address(0xF00),
                        makeAddr("organizer"),
                        DEPOSIT,
                        eventStart - 7 days,
                        eventStart,
                        eventStart + 1 days,
                        uint256(1 days),
                        uint256(0),
                        "ipfs://meta"
                    )
                )
            )
        );
    }
}
