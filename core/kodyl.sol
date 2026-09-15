// Shared helpers for the Kodyl Core Solidity implementation, imported as
// `import * from lib.kodyl;`. Each definition here is a piece of
// infrastructure the language does not provide yet (checked math, error
// selectors and revert builders, event codegen, named constants, env
// globals); the protocol itself lives in Kodyl.sol.
import * from std;
import {caller as caller_, callvalue as callvalue_, timestamp, selfbalance,
        gas, call, shr, mload, mstore, revert_,
        log1 as log1_, log2 as log2_, log3 as log3_,
        chainid as chainid_, address as address_} from std.opcodes;

export {
    ErrSel,
    fail,
    requireK,
    caller,
    caller_value,
    timeNow,
    balanceSelf,
    chainId,
    self,
    recoverStrict,
    panic,
    solAssert,
    addCk,
    subCk,
    mulCk,
    revertWith2,
    revertStr,
    revertStr1,
    sendValue,
    emitLog1,
    emitLog2,
    emitLog3,
    emitLog3W1,
    emitLog3W3,
    emitLog2Str,
    validateEventParams,
    maxBatchSize,
    dustClaimTimeout,
    minCancellationBuffer,
    disputePeriodMin,
    disputePeriodMax,
    rewardCapMultiple
};

// --- protocol constants ---
// No constant keyword in the language yet, so nullary functions are the single
// source of truth; every consumer calls these instead of repeating literals.

// Hard cap on a checkInBatch array length.
function maxBatchSize() returns (uint256) { return 100; }

// 30 days after the dispute window: unclaimed payouts sweep to the maintainer.
function dustClaimTimeout() returns (uint256) { return 2592000; }

// 2 hours: minimum gap between the cancellation deadline and event start.
function minCancellationBuffer() returns (uint256) { return 7200; }

// Attendance reward ceiling, as a multiple of the deposit: showing up can at
// most double your stake. Bounds what a checked-in sybil can capture - the
// excess above the cap rebates to the no-shows instead (see calcRebate).
function rewardCapMultiple() returns (uint256) { return 1; }

// 1 hour: shortest allowed dispute period.
function disputePeriodMin() returns (uint256) { return 3600; }

// 30 days: longest allowed dispute period. Equal to dustClaimTimeout by
// coincidence only - the two must stay separate.
function disputePeriodMax() returns (uint256) { return 2592000; }

// --- error selectors ---
// An error signature literal at an ErrSel-typed position folds to its
// right-aligned 4-byte selector at compile time (per-literal clone-and-erase
// of fromString), so error sites read fail("X()") with no hash constants in
// source.

enum ErrSel { ErrSel(word) }

impl Str<ErrSel> {
    function fromString(s: string) returns (ErrSel) {
        return ErrSel(shr(224, keccakLit(s)));
    }
}

// Unconditional zero-arg custom-error revert.
function fail(e: ErrSel) {
    match (e) {
    case ErrSel(w) { require(false, Error(w)); }
    }
}

// require with a zero-arg custom error. No short-circuit in the language, so
// callers must not fold compound guards into cond casually.
function requireK(cond: bool, e: ErrSel) {
    match (e) {
    case ErrSel(w) { require(cond, Error(w)); }
    }
}

// --- environment ---

function caller() returns (address) {
    return address(caller_());
}

function caller_value() returns (uint256) {
    return uint256(callvalue_());
}

function timeNow() returns (uint256) {
    return uint256(timestamp());
}

function balanceSelf() returns (uint256) {
    return uint256(selfbalance());
}

function chainId() returns (uint256) {
    return uint256(chainid_());
}

function self() returns (address) {
    return address(address_());
}

// ecrecover with the scratch slot zeroed first. Historical shim: the std
// ecrecover at this pin pre-zeroes the scratch itself (the upstream defect we
// filed was fixed), so this wrapper is now redundant defense in depth. It is
// removed - and call sites go straight to std ecrecover - in the follow-up
// commit, kept through the mechanical migration so this commit changes
// spelling only.
function recoverStrict(digest: bytes32, v: uint256, r: bytes32, s: bytes32) returns (address) {
    mstore(0, 0);
    return ecrecover(digest, v, r, s);
}

// NOTE: the split-signature helper (enum Sig + splitSig) lives in Kodyl.sol,
// not here, although this module is its natural home: at the OLD pin,
// pattern-matching a constructor imported from another module failed SC0107.
// The new qualified-pattern path lifts that restriction (probed at this pin),
// so the pair moves here in the follow-up commit.

// --- Solidity 0.8 semantics shims ---
// Core Solidity arithmetic wraps and its assert hits the invalid opcode, so
// Panic(uint256) reverts are reproduced by hand exactly where the logic
// needs checked math (the checked-arithmetic shim).

function panic(code: word) {
    let p = get_free_memory();
    mstore(p, 0x4e487b71); // Panic(uint256) selector, right-aligned in the word
    mstore(p + 32, code);
    revert_(p + 28, 36);
}

function solAssert(cond: bool) {
    if (!cond) { panic(0x01); }
}

function addCk(x: uint256, y: uint256) returns (uint256) {
    let r = x + y;
    if (r < x) { panic(0x11); }
    return r;
}

function subCk(x: uint256, y: uint256) returns (uint256) {
    if (y > x) { panic(0x11); }
    return x - y;
}

function mulCk(x: uint256, y: uint256) returns (uint256) {
    if (x == 0) { return 0; }
    let r = x * y;
    if (r / x != y) { panic(0x11); }
    return r;
}

// --- revert payload builders ---
// Errors WITH arguments need hand-built payloads matching abi.encodeWithSelector:
// right-aligned 4-byte selector followed by 32-byte words. Call sites pass the
// error signature literal, which folds to the selector through Str<ErrSel>.

function revertWith2(e: ErrSel, a: word, b: word) {
    match (e) {
    case ErrSel(sel) {
        let p = get_free_memory();
        mstore(p, sel);      // selector occupies bytes p+28..p+31
        mstore(p + 32, a);
        mstore(p + 64, b);
        revert_(p + 28, 68);
    }
    }
}

// Error(string)-shaped revert from a source literal: sel ++ abi.encode(string)
// = selector (4 bytes, right-aligned) ++ 0x20 ++ len ++ padded data. Native
// require(cond, "msg") reverts with RAW message bytes, so the Solidity wire
// shape is still built by hand; only the reason string lives in source.
// The literal materializer zero-pads its final word, so whole-word copies are
// byte-exact. Terminal code (revert follows), so free memory is not advanced.
function revertStr(e: ErrSel, msg: memory<string>) {
    match (e) {
    case ErrSel(sel) {
        let p = get_free_memory();
        mstore(p, sel);
        mstore(p + 32, 32);  // offset of the string head
        let sptr = Typedef.rep(msg);
        let len = mload(sptr);
        mstore(p + 64, len);
        let padded = shr(5, len + 31) * 32;
        for (let i: word = 0; i < padded; i = i + 32) {
            mstore(p + 96 + i, mload(sptr + 32 + i));
        }
        revert_(p + 28, 68 + padded);
    }
    }
}

// One-word packed variant kept for EXACTLY ONE site: the constructor's zero
// address guard. String literals do not materialize in deploy code (the
// allocators are emitted into the runtime object only; solcore
// doc/comptime-string.md gap table), so the constructor cannot go through
// revertStr - this packed word is the deliberate exhibit of that gap.
function revertStr1(sel: word, len: word, w0: word) {
    let p = get_free_memory();
    mstore(p, sel);
    mstore(p + 32, 32);  // offset of the string head
    mstore(p + 64, len);
    mstore(p + 96, w0);
    revert_(p + 28, 100);
}

// --- event parameter validation ---
// Guard order and InvalidEventParameters(string) payloads are pinned
// byte-for-byte by the forge suite; reason strings are source literals fed
// through revertStr.

function validateEventParams(
    depositAmount: uint256,
    cancellationDeadline: uint256,
    eventStart: uint256,
    eventEnd: uint256,
    disputePeriod: uint256
) {
    if (depositAmount == 0) {
        revertStr("InvalidEventParameters(string)", "Deposit must be > 0");
    }
    if (eventStart <= timeNow()) {
        revertStr("InvalidEventParameters(string)", "Event must start in future");
    }
    if (eventEnd <= eventStart) {
        revertStr("InvalidEventParameters(string)", "Event end must be after start");
    }
    // Written as an addition (not eventStart - buffer) so it cannot underflow
    // for near-term events; addCk keeps 0.8 checked semantics.
    if (addCk(cancellationDeadline, minCancellationBuffer()) > eventStart) {
        revertStr("InvalidEventParameters(string)", "Cancellation deadline too late");
    }
    if (cancellationDeadline <= timeNow()) {
        revertStr("InvalidEventParameters(string)", "Cancellation deadline must be in future");
    }
    if (disputePeriod < disputePeriodMin()) {
        revertStr("InvalidEventParameters(string)", "Dispute period too short");
    }
    if (disputePeriod > disputePeriodMax()) {
        revertStr("InvalidEventParameters(string)", "Dispute period too long");
    }
}

// --- ETH transfer (weth9 pattern) ---

function sendValue(dst: address, wad: uint256) {
    let ret = call(gas(), Typedef.rep(dst), Typedef.rep(wad), 0, 0, 0, 0);
    requireK(ret != 0, "TransferFailed()");
}

// --- event emission (no emit sugar in the language) ---
// Generic over topics: callers pass raw words (Typedef.rep their values) and
// derive topic0 in place with compile-time-folded keccakLit of the canonical
// signature, so no hash constants appear anywhere in the sources.

// E() anonymous-data-free: topic0 only.
function emitLog1(t0: word) {
    log1_(0, 0, t0);
}

// E(x indexed): one topic, no data.
function emitLog2(t0: word, t1: word) {
    log2_(0, 0, t0, t1);
}

// E(x indexed, y indexed): two topics, no data.
function emitLog3(t0: word, t1: word, t2: word) {
    log3_(0, 0, t0, t1, t2);
}

// E(x indexed, y indexed, z): two topics, one data word.
function emitLog3W1(t0: word, t1: word, t2: word, d0: word) {
    let p = get_free_memory();
    mstore(p, d0);
    log3_(p, 32, t0, t1, t2);
}

// E(x indexed, y indexed, a, b, c): two topics, three data words.
function emitLog3W3(t0: word, t1: word, t2: word,
                    d0: word, d1: word, d2: word) {
    let p = get_free_memory();
    mstore(p, d0);
    mstore(p + 32, d1);
    mstore(p + 64, d2);
    log3_(p, 96, t0, t1, t2);
}

// E(x indexed, string s): one topic, data = abi.encode(s). abi_encode
// returns memory<bytes>: its rep points at a byte-length word with the
// encoded payload in the following len bytes, so the log data starts one
// word in and spans exactly that length.
function emitLog2Str(t0: word, t1: word, s: memory<string>) {
    let enc = abi_encode(s);
    let bptr = Typedef.rep(enc);
    log2_(bptr + 32, mload(bptr), t0, t1);
}
