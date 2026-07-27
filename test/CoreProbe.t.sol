// SPDX-License-Identifier: MIT
pragma solidity ^0.8.33;

import {Test} from "forge-std/Test.sol";
import {CoreDeploy} from "./CoreDeploy.sol";

/// @notice Toolchain gate: proves the full sol-core -> yule -> solc -> forge
///         pipeline (constructor args, dispatch, opcode wrappers) and pins the
///         runtime behavior of every language-feature canary in Probe.solc.
contract CoreProbeTest is Test {
    address p;

    function setUp() public {
        p = CoreDeploy.deploy("Probe", abi.encode(uint256(42)));
    }

    function test_probe_ctorArgs_dispatch_and_opcode() public {
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

    /// require(cond, "message"): the failure payload is the RAW UTF-8 bytes of
    /// the message - no Error(string) selector, no ABI head. This wire shape is
    /// exactly why Kodyl keeps its Solidity-shaped revert builders and feeds
    /// them source literals instead of adopting native require on the ABI
    /// surface.
    function test_probe_requireMessage_revertsRawBytes() public {
        (bool ok, bytes memory ret) =
            p.call(abi.encodeWithSignature("demandPositive(uint256)", 5));
        assertTrue(ok, "happy path reverted");
        assertEq(abi.decode(ret, (uint256)), 5);

        (ok, ret) = p.call(abi.encodeWithSignature("demandPositive(uint256)", 0));
        assertFalse(ok, "zero did not revert");
        assertEq(ret, bytes("Probe: x must be positive"), "revert is not raw message bytes");
    }

    /// User-defined Str instance: the literal "EventNotFound()" folds to its
    /// canonical right-aligned 4-byte selector at compile time.
    function test_probe_strInstance_foldsSelector() public {
        (bool ok, bytes memory ret) = p.call(abi.encodeWithSignature("selOf()"));
        assertTrue(ok, "selOf() reverted");
        assertEq(
            abi.decode(ret, (uint256)),
            uint256(uint32(bytes4(keccak256("EventNotFound()")))),
            "folded selector mismatch"
        );
    }

    /// UFCS storage-array methods (push/length/index) on an array(string) field.
    function test_probe_ufcsStorageArray() public {
        (bool ok,) = p.call(abi.encodeWithSignature("pushUri(string)", "ipfs://one"));
        assertTrue(ok, "first push reverted");
        (ok,) = p.call(abi.encodeWithSignature("pushUri(string)", "ipfs://two"));
        assertTrue(ok, "second push reverted");

        (bool ok2, bytes memory ret) = p.call(abi.encodeWithSignature("uriCount()"));
        assertTrue(ok2, "uriCount() reverted");
        assertEq(abi.decode(ret, (uint256)), 2);

        (ok2, ret) = p.call(abi.encodeWithSignature("uriAt(uint256)", 1));
        assertTrue(ok2, "uriAt() reverted");
        assertEq(abi.decode(ret, (string)), "ipfs://two", "string round-trip failed");
    }

    /// Bare integer literals in non-tail returns (call-expected-type
    /// unification).
    function test_probe_bareLiteralNonTailReturn() public {
        (bool ok, bytes memory ret) = p.call(abi.encodeWithSignature("bareLit(uint256)", 0));
        assertTrue(ok);
        assertEq(abi.decode(ret, (uint256)), 1);
        (ok, ret) = p.call(abi.encodeWithSignature("bareLit(uint256)", 7));
        assertTrue(ok);
        assertEq(abi.decode(ret, (uint256)), 0);
    }
}
