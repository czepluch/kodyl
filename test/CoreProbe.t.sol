// SPDX-License-Identifier: MIT
pragma solidity ^0.8.33;

import {Test} from "forge-std/Test.sol";
import {CoreDeploy} from "./CoreDeploy.sol";

/// @notice M0 gate: proves the full sol-core -> yule -> solc -> forge pipeline,
///         including constructor-arg delivery and dispatch selector compatibility.
contract CoreProbeTest is Test {
    function test_probe_ctorArgs_dispatch_and_opcode() public {
        address p = CoreDeploy.deploy("Probe", abi.encode(uint256(42)));

        (bool ok, bytes memory ret) = p.call(abi.encodeWithSignature("get()"));
        assertTrue(ok, "get() reverted");
        assertEq(abi.decode(ret, (uint256)), 42, "ctor arg lost");

        vm.warp(1_700_000_000);
        (ok, ret) = p.call(abi.encodeWithSignature("timeNow()"));
        assertTrue(ok, "timeNow() reverted");
        assertEq(abi.decode(ret, (uint256)), 1_700_000_000, "timestamp mismatch");

        // Unknown selector must revert (default dispatch behavior).
        (ok,) = p.call(abi.encodeWithSignature("nope()"));
        assertFalse(ok, "unknown selector did not revert");
    }
}
