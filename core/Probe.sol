// Toolchain probe: exercises constructor args, storage, dispatch, and an
// opcode wrapper end-to-end, plus a canary for every language feature the
// showcase migrations lean on. check-core.sh compiles this file FIRST, so
// toolchain drift fails here - small and labeled - before Kodyl does.
//
// Canaries (each maps to a Kodyl.sol pattern):
//   demandPositive  require(cond, "message") - runtime string literals; the
//                   native revert is RAW message bytes, not Solidity
//                   Error(string); CoreProbe.t.sol pins that wire shape
//   selOf           user-defined Str impl folding keccakLit at compile
//                   time (the ErrSel error-selector pattern)
//   pushUri/...     UFCS method calls on a storage array of strings
//   bareLit         bare integer literal in a non-tail return (the
//                   call-result/expected-type unification fix)
//   eipDomain/...   std eip712 helpers + a hand-rolled hashStruct via nested
//                   two-arg concat (the Ticket/Presence hashing pattern)
//   recoverSigner   std ecrecover: split v/r/s form, reverts on failure
//   addrAt/...      lazy calldata dynamic-array params: address (static
//                   elements), memory<bytes> (dynamic elements), and uint256
//                   (no upstream fixture - this canary is the coverage)
import * from std;
import {timestamp, shr} from std.opcodes;
import * from std.dispatch;
import * from std.eip712;

// A selector type constructible from the error-signature literal itself:
// "X()" folds to its right-aligned 4-byte selector at compile time via the
// per-literal clone-and-erase of fromString. No runtime cost, no hash
// constants in source. Mirrors lib.kodyl's ErrSel exactly, word payload
// included. Constraint: std.ABIGeneric must NOT be imported into a module
// defining word-payload enums - its derive fires for every local type and
// bare word has no ABIDecode instance (SC0223). The calldata-array params
// below decode without it.
enum Sel { Sel(word) }

impl Str<Sel> {
    function fromString(s: string) returns (Sel) {
        return Sel(shr(224, keccakLit(s)));
    }
}

contract Probe {
    stored: uint256;
    uris: array<string>;

    constructor(x: uint256) {
        stored = x;
    }

    function get() public returns (uint256) {
        return stored;
    }

    function timeNow() public returns (uint256) {
        return uint256(timestamp());
    }

    // require with a runtime-materialized string literal. On failure the
    // revert payload is the raw UTF-8 bytes of the message (std's Error.Msg
    // shape) - deliberately NOT the Solidity Error(string) ABI encoding.
    function demandPositive(x: uint256) public returns (uint256) {
        require(x > 0, "Probe: x must be positive");
        return x;
    }

    // The literal resolves through the Str<Sel> impl above and folds to
    // the canonical selector of EventNotFound() as a compile-time constant.
    function selOf() public returns (uint256) {
        let e: Sel = "EventNotFound()";
        match (e) {
        case Sel(w) { return uint256(w); }
        }
    }

    // UFCS storage-array methods on a contract field.
    function pushUri(u: memory<string>) public returns (()) {
        uris.push(u);
    }

    function uriCount() public returns (uint256) {
        return uris.length();
    }

    function uriAt(i: uint256) public returns (memory<string>) {
        return uris[i];
    }

    // Bare literal in a non-tail return: rejected before the
    // call-expected-type unification landed, accepted at the current pin.
    function bareLit(x: uint256) public returns (uint256) {
        if (x > 0) { return 0; }
        return 1;
    }

    // std eip712: hashStruct of the standard EIP712Domain shape. Name and
    // version go in pre-hashed (keccakLit folds them at compile time).
    function eipDomain(chainId: uint256, verifying: address) public returns (bytes32) {
        return eip712DomainSeparator(
            bytes32(keccakLit("Probe")),
            bytes32(keccakLit("1")),
            chainId,
            verifying
        );
    }

    // Hand-rolled hashStruct (typeHash then one word per member) via nested
    // two-arg concat - there is no hashStruct helper in std, so this is the
    // pattern any message struct hash must use.
    function eipStructHash(a: uint256, b: address) public returns (bytes32) {
        let typeHash = bytes32(keccakLit("Pair(uint256 a,address b)"));
        return keccak256_(concat(
            typeHash,
            concat(bytes32(Typedef.rep(a)), bytes32(Typedef.rep(b)))
        ));
    }

    // std eip712: the 0x1901 combinator over the domain above.
    function eipDigest(chainId: uint256, verifying: address, structHash: bytes32) public returns (bytes32) {
        let dom = eip712DomainSeparator(
            bytes32(keccakLit("Probe")),
            bytes32(keccakLit("1")),
            chainId,
            verifying
        );
        return eip712Digest(dom, structHash);
    }

    // std ecrecover: split v/r/s form only (no 65-byte or EIP-2098 overload).
    // Reverts rather than returning zero: MalleableSignatureRejected() on
    // high-s, ECRecoverCallFailed() if the precompile call fails,
    // ECRecoverFailed() if it returns no signer.
    function recoverSigner(digest: bytes32, v: uint256, r: bytes32, s: bytes32) public returns (address) {
        return ecrecover(digest, v, r, s);
    }

    // Lazy calldata dynamic arrays: static elements (address)...
    function addrAt(items: calldata<array<address>>, i: uint256) public returns (address) {
        return items[i];
    }

    function addrCount(items: calldata<array<address>>) public returns (uint256) {
        return items.length();
    }

    // ...dynamic elements (the element type is spelled memory<bytes>)...
    function bytesAt(items: calldata<array<memory<bytes>>>, i: uint256) public returns (memory<bytes>) {
        return items[i];
    }

    function bytesCount(items: calldata<array<memory<bytes>>>) public returns (uint256) {
        return items.length();
    }

    // ...and uint256 elements, which no upstream fixture covers: indexing
    // (with the ArrayOutOfBounds() auto-revert) plus a full iteration.
    function uintAt(items: calldata<array<uint256>>, i: uint256) public returns (uint256) {
        return items[i];
    }

    function sumOf(items: calldata<array<uint256>>) public returns (uint256) {
        let n = items.length();
        let total = uint256(0);
        for (let i = uint256(0); i < n; i = i + 1) {
            total = total + items[i];
        }
        return total;
    }
}
