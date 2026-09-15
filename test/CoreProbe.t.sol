// SPDX-License-Identifier: MIT
pragma solidity ^0.8.33;

import {Test} from "forge-std/Test.sol";
import {CoreDeploy} from "./CoreDeploy.sol";

/// @notice Toolchain gate: proves the full sol-core -> yule -> solc -> forge
///         pipeline (constructor args, dispatch, opcode wrappers) and pins the
///         runtime behavior of every language-feature canary in Probe.solc.
contract CoreProbeTest is Test {
    address p;

    // std ecrecover failure selectors and the lazy calldata-array bounds
    // selector, derived from their signatures; the literal-value asserts in
    // the tests pin them to the documented constants.
    bytes4 constant MALLEABLE_SEL = bytes4(keccak256("MalleableSignatureRejected()"));
    bytes4 constant ECREC_CALL_FAILED_SEL = bytes4(keccak256("ECRecoverCallFailed()"));
    bytes4 constant ECREC_FAILED_SEL = bytes4(keccak256("ECRecoverFailed()"));
    bytes4 constant OOB_SEL = bytes4(keccak256("ArrayOutOfBounds()"));

    uint256 constant SECP256K1_N =
        0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141;

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

    /// std eip712: domain separator and 0x1901 digest match an independent
    /// Solidity computation of the same EIP-712 layers.
    function test_probe_eip712_domainSeparator_and_digest() public {
        uint256 cid = 31337;
        address ver = address(0xCcCCccccCCCCcCCCCCCcCcCccCcCCCcCcccccccC);
        bytes32 expectedDom = keccak256(abi.encode(
            keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"),
            keccak256("Probe"),
            keccak256("1"),
            cid,
            ver
        ));

        (bool ok, bytes memory ret) =
            p.call(abi.encodeWithSignature("eipDomain(uint256,address)", cid, ver));
        assertTrue(ok, "eipDomain reverted");
        assertEq(abi.decode(ret, (bytes32)), expectedDom, "domain separator mismatch");

        bytes32 structHash = keccak256("arbitrary struct hash");
        bytes32 expectedDigest =
            keccak256(abi.encodePacked(hex"1901", expectedDom, structHash));
        (ok, ret) = p.call(abi.encodeWithSignature(
            "eipDigest(uint256,address,bytes32)", cid, ver, structHash));
        assertTrue(ok, "eipDigest reverted");
        assertEq(abi.decode(ret, (bytes32)), expectedDigest, "0x1901 digest mismatch");
    }

    /// Hand-rolled hashStruct via nested two-arg concat equals
    /// keccak256(abi.encode(typeHash, members...)).
    function test_probe_eip712_handRolledStructHash() public {
        uint256 a = 7;
        address b = address(0xBEEF);
        bytes32 expected = keccak256(abi.encode(
            keccak256("Pair(uint256 a,address b)"), a, b));
        (bool ok, bytes memory ret) =
            p.call(abi.encodeWithSignature("eipStructHash(uint256,address)", a, b));
        assertTrue(ok, "eipStructHash reverted");
        assertEq(abi.decode(ret, (bytes32)), expected, "hashStruct mismatch");
    }

    /// std ecrecover round-trips a vm.sign signature to the signer address.
    function test_probe_ecrecover_roundTrip() public {
        uint256 pk = 0xA11CE;
        bytes32 digest = keccak256("kodyl ecrecover canary");
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(pk, digest);
        (bool ok, bytes memory ret) = p.call(abi.encodeWithSignature(
            "recoverSigner(bytes32,uint256,bytes32,bytes32)", digest, uint256(v), r, s));
        assertTrue(ok, "recoverSigner reverted on a valid signature");
        assertEq(abi.decode(ret, (address)), vm.addr(pk), "wrong signer recovered");
    }

    /// High-s form of a valid signature reverts MalleableSignatureRejected()
    /// instead of recovering.
    function test_probe_ecrecover_malleableHighS_reverts() public {
        assertEq(MALLEABLE_SEL, bytes4(0x25260b20), "documented selector moved");
        bytes32 digest = keccak256("kodyl ecrecover canary");
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(0xA11CE, digest);
        bytes32 sHigh = bytes32(SECP256K1_N - uint256(s));
        uint256 vFlip = v == 27 ? 28 : 27;
        (bool ok, bytes memory ret) = p.call(abi.encodeWithSignature(
            "recoverSigner(bytes32,uint256,bytes32,bytes32)", digest, vFlip, r, sHigh));
        assertFalse(ok, "high-s signature did not revert");
        assertEq(ret, abi.encodeWithSelector(MALLEABLE_SEL), "wrong revert payload");
    }

    /// A signature the precompile cannot recover (r = 0) reverts
    /// ECRecoverFailed(): the staticcall SUCCEEDS with empty returndata (the
    /// precompile never fails on bad input), nothing is copied into scratch,
    /// std reads the clean-scratch zero and reverts rather than returning the
    /// zero address.
    function test_probe_ecrecover_invalid_revertsFailed() public {
        assertEq(ECREC_FAILED_SEL, bytes4(0x4fbfae63), "documented selector moved");
        bytes32 digest = keccak256("kodyl ecrecover canary");
        (bool ok, bytes memory ret) = p.call(abi.encodeWithSignature(
            "recoverSigner(bytes32,uint256,bytes32,bytes32)",
            digest, uint256(27), bytes32(0), bytes32(uint256(1))));
        assertFalse(ok, "invalid signature did not revert");
        assertEq(ret, abi.encodeWithSelector(ECREC_FAILED_SEL), "wrong revert payload");
    }

    /// ECRecoverCallFailed() is declared but unobservable: the only way the
    /// precompile staticcall can fail is gas starvation, and when it does the
    /// forwarded 63/64 is consumed whole - the 1/64 remainder cannot fund the
    /// revert-with-payload path, so the frame ends as a plain OOG with empty
    /// returndata. A step-1 sweep across the entire starvation window (above
    /// 24000 gas the precompile always has its 3000) proves the selector never
    /// reaches the wire; every failure in the window is an empty-returndata
    /// OOG. If a std or gas-schedule change opens the window, this flips.
    function test_probe_ecrecover_gasStarved_isPlainOogNotCallFailed() public {
        assertEq(ECREC_CALL_FAILED_SEL, bytes4(0x578763f7), "documented selector moved");
        bytes32 digest = keccak256("kodyl ecrecover canary");
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(0xA11CE, digest);
        bytes memory cd = abi.encodeWithSignature(
            "recoverSigner(bytes32,uint256,bytes32,bytes32)", digest, uint256(v), r, s);
        uint256 failures;
        for (uint256 g = 2000; g <= 24000; g++) {
            (bool ok, bytes memory ret) = p.call{gas: g}(cd);
            if (!ok) {
                failures++;
                assertEq(ret.length, 0, "starved frame produced a revert payload");
            }
        }
        assertGt(failures, 0, "sweep produced no OOG failures at all");
        // Pin the sweep's exhaustiveness: the top of the swept range must
        // succeed outright. Gas is monotone here (the only gas-dependent
        // branch is the staticcall forwarding gas(), and precompile 1 cannot
        // fail a valid input for non-gas reasons), so success at 24000
        // extends to all higher gas - the starvation window lies entirely
        // inside the sweep. Without this, dispatch-cost growth could push
        // the window above 24000 and the loop would pass vacuously.
        (bool okTop, bytes memory retTop) = p.call{gas: 24000}(cd);
        assertTrue(okTop, "top of swept range did not succeed - window escaped the sweep");
        assertEq(abi.decode(retTop, (address)), vm.addr(0xA11CE), "wrong signer at window top");
    }

    /// calldata(array(address)): length, indexing, and the ArrayOutOfBounds()
    /// auto-revert on an out-of-range index.
    function test_probe_calldataAddressArray() public {
        assertEq(OOB_SEL, bytes4(0x7f52b2bf), "documented selector moved");
        address[] memory arr = new address[](2);
        arr[0] = address(0x1111111111111111111111111111111111111111);
        arr[1] = address(0x2222222222222222222222222222222222222222);

        (bool ok, bytes memory ret) =
            p.call(abi.encodeWithSignature("addrCount(address[])", arr));
        assertTrue(ok, "addrCount reverted");
        assertEq(abi.decode(ret, (uint256)), 2);

        (ok, ret) = p.call(abi.encodeWithSignature("addrAt(address[],uint256)", arr, 1));
        assertTrue(ok, "addrAt reverted");
        assertEq(abi.decode(ret, (address)), arr[1]);

        (ok, ret) = p.call(abi.encodeWithSignature("addrAt(address[],uint256)", arr, 2));
        assertFalse(ok, "out-of-range index did not revert");
        assertEq(ret, abi.encodeWithSelector(OOB_SEL), "wrong revert payload");

        (ok, ret) = p.call(abi.encodeWithSignature("addrCount(address[])", new address[](0)));
        assertTrue(ok, "addrCount on empty reverted");
        assertEq(abi.decode(ret, (uint256)), 0);
    }

    /// calldata(array(memory(bytes))): dynamic elements round-trip through the
    /// offset table. One element is a realistic 65-byte r||s||v signature (the
    /// ticketSigs/presenceSigs wire shape) so the multi-word tail - length
    /// rounding plus a copy spanning three words - is exercised, not just
    /// sub-word tails. Bounds and the empty array are probed on this path too.
    function test_probe_calldataBytesArray() public {
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(0xA11CE, keccak256("sig-shaped element"));
        bytes[] memory arr = new bytes[](2);
        arr[0] = abi.encodePacked(r, s, v);
        arr[1] = hex"ccddee";
        assertEq(arr[0].length, 65, "signature element must span multiple words");

        (bool ok, bytes memory ret) =
            p.call(abi.encodeWithSignature("bytesCount(bytes[])", arr));
        assertTrue(ok, "bytesCount reverted");
        assertEq(abi.decode(ret, (uint256)), 2);

        (ok, ret) = p.call(abi.encodeWithSignature("bytesAt(bytes[],uint256)", arr, 0));
        assertTrue(ok, "bytesAt(0) reverted");
        assertEq(abi.decode(ret, (bytes)), arr[0]);

        (ok, ret) = p.call(abi.encodeWithSignature("bytesAt(bytes[],uint256)", arr, 1));
        assertTrue(ok, "bytesAt(1) reverted");
        assertEq(abi.decode(ret, (bytes)), arr[1]);

        (ok, ret) = p.call(abi.encodeWithSignature("bytesAt(bytes[],uint256)", arr, 2));
        assertFalse(ok, "out-of-range index did not revert");
        assertEq(ret, abi.encodeWithSelector(OOB_SEL), "wrong revert payload");

        (ok, ret) = p.call(abi.encodeWithSignature("bytesCount(bytes[])", new bytes[](0)));
        assertTrue(ok, "bytesCount on empty reverted");
        assertEq(abi.decode(ret, (uint256)), 0);
    }

    /// calldata(array(uint256)): no upstream fixture exists for uint256
    /// element decoding - this canary is the coverage. Indexing, bounds, and
    /// a full iteration (sum).
    function test_probe_calldataUintArray() public {
        uint256[] memory arr = new uint256[](3);
        arr[0] = 7;
        arr[1] = 35;
        arr[2] = 100;

        (bool ok, bytes memory ret) =
            p.call(abi.encodeWithSignature("uintAt(uint256[],uint256)", arr, 2));
        assertTrue(ok, "uintAt reverted");
        assertEq(abi.decode(ret, (uint256)), 100);

        (ok, ret) = p.call(abi.encodeWithSignature("uintAt(uint256[],uint256)", arr, 3));
        assertFalse(ok, "out-of-range index did not revert");
        assertEq(ret, abi.encodeWithSelector(OOB_SEL), "wrong revert payload");

        (ok, ret) = p.call(abi.encodeWithSignature("sumOf(uint256[])", arr));
        assertTrue(ok, "sumOf reverted");
        assertEq(abi.decode(ret, (uint256)), 142, "iteration sum mismatch");
    }

    /// Enum with a struct payload stored in a mapping (the EventRec shape):
    /// an unset key reads back as the first constructor (tag 0 = Empty), and
    /// the match-bound payload supports named field access.
    function test_probe_enumStructPayloadInMapping() public {
        (bool ok,) = p.call(abi.encodeWithSignature("slotA(uint256)", 7));
        assertFalse(ok, "unset slot did not read as Empty and revert");

        (ok,) = p.call(abi.encodeWithSignature("putSlot(uint256,uint256,address)", 7, 123, address(0xBEEF)));
        assertTrue(ok, "putSlot reverted");

        (bool ok2, bytes memory ret) = p.call(abi.encodeWithSignature("slotA(uint256)", 7));
        assertTrue(ok2, "slotA reverted after put");
        assertEq(abi.decode(ret, (uint256)), 123, "payload field mismatch");

        // A different key still reads Empty: no cross-key bleed.
        (ok,) = p.call(abi.encodeWithSignature("slotA(uint256)", 8));
        assertFalse(ok, "neighbouring key not Empty");
    }

    /// Struct as a mapping value with the read-reconstruct-write update (the
    /// Counters idiom; member writes through a mapping value are
    /// unimplemented at this pin, SC0231).
    function test_probe_structMappingValueUpdate() public {
        (bool ok,) = p.call(abi.encodeWithSignature("bumpTally(uint256,uint256)", 1, 11));
        assertTrue(ok, "first bump reverted");
        (ok,) = p.call(abi.encodeWithSignature("bumpTally(uint256,uint256)", 1, 22));
        assertTrue(ok, "second bump reverted");

        (bool ok2, bytes memory ret) = p.call(abi.encodeWithSignature("tallyOf(uint256)", 1));
        assertTrue(ok2, "tallyOf reverted");
        (uint256 hits, uint256 last) = abi.decode(ret, (uint256, uint256));
        assertEq(hits, 2, "untouched-then-bumped field lost an update");
        assertEq(last, 22, "reconstructed field not last write");
    }

    /// ERC-7201-namespaced slots via comptime erc7201 + hash2 with raw
    /// sload/sstore (the lib.ledger custody pattern): round-trip per key,
    /// isolation across keys.
    function test_probe_namespacedSlots() public {
        (bool ok,) = p.call(abi.encodeWithSignature("nsWrite(uint256,uint256)", 5, 99));
        assertTrue(ok, "nsWrite reverted");

        (bool ok2, bytes memory ret) = p.call(abi.encodeWithSignature("nsRead(uint256)", 5));
        assertTrue(ok2, "nsRead reverted");
        assertEq(abi.decode(ret, (uint256)), 99, "namespaced round-trip lost the value");

        (ok2, ret) = p.call(abi.encodeWithSignature("nsRead(uint256)", 6));
        assertTrue(ok2, "nsRead(6) reverted");
        assertEq(abi.decode(ret, (uint256)), 0, "unset namespaced key not zero");
    }
}
