// SPDX-License-Identifier: MIT
pragma solidity ^0.8.33;

import {Test} from "forge-std/Test.sol";
import {CoreDeploy} from "./CoreDeploy.sol";

contract DebugStencilTest is Test {
    function test_stencil_roundtrip() public {
        bytes memory init = CoreDeploy.initcode("KodylEvent");
        bytes memory code = bytes.concat(hex"600d380380600d6000396000f3", init);
        address s;
        assembly ("memory-safe") { s := create(0, add(code, 0x20), mload(code)) }
        require(s != address(0), "stencil failed");
        // 1: stencil runtime must equal the initcode byte-for-byte
        assertEq(s.code, init, "stencil code != initcode");

        // 2: replicate V2's create2 in Solidity: stencil code ++ abi.encode(args)
        bytes memory withArgs = bytes.concat(
            s.code,
            abi.encode(address(this), address(0xBEEF), uint256(1 ether),
                       uint256(1), uint256(2), uint256(3), uint256(4), uint256(0), "ipfs://meta")
        );
        address evt;
        assembly ("memory-safe") { evt := create2(0, add(withArgs, 0x20), mload(withArgs), 0x1234) }
        assertTrue(evt != address(0), "create2 returned 0");
        emit log_named_uint("deployed code size", evt.code.length);
        assertGt(evt.code.length, 0, "empty runtime");
    }
}
