// The custody ledger: the per-event pot, the global total, and the ONLY path
// by which ETH leaves the contract.
//
// This module is the opaque-boundary pattern applied to accounting. The slot
// accessors and the raw transfer are module-private and the export list is
// the entire API: outside this module no code path can move pot value or
// send ETH except through credit / payOut, so "debit both ledgers, then
// send, then check the balance invariant" stops being a discipline reviewers
// verify at every call site and becomes the only reachable order. The
// balance >= total invariant is asserted HERE - after every credit and every
// payout - instead of remembered five times in the contract.
//
// Storage: module-owned ERC-7201-namespaced slots rather than contract
// fields (storage declarations are contract-scoped in the language, so a
// module that owns state addresses it by namespace hash). The pot mapping
// slot for an event is hash2(namespace, eid), the same shape Solidity gives
// a mapping behind a slot; unset slots read zero, keeping the repo-wide
// zero-slot rule: an unknown event's pot is 0.
import * from std;
import {sload, sstore, gas, call} from std.opcodes;
import * from lib.kodyl;

export { potOf, ledgerTotal, credit, payOut };

// --- module-private storage ---

function totalSlot() returns (word) {
    return Typedef.rep(erc7201("kodyl.ledger.total"));
}

function potSlot(eid: uint256) returns (word) {
    return hash2(Typedef.rep(erc7201("kodyl.ledger.pot")), Typedef.rep(eid));
}

function readTotal() returns (uint256) {
    return uint256(sload(totalSlot()));
}

function readPot(eid: uint256) returns (uint256) {
    return uint256(sload(potSlot(eid)));
}

// --- reads (exported) ---

function potOf(eid: uint256) returns (uint256) {
    return readPot(eid);
}

function ledgerTotal() returns (uint256) {
    return readTotal();
}

// --- the two reachable mutations (exported) ---

// A deposit came in with the call: attribute it to the event's pot and the
// global total, then check the balance covers the ledger. Checked adds keep
// Solidity 0.8 overflow semantics (Panic 0x11).
function credit(eid: uint256, amount: uint256) {
    sstore(potSlot(eid), Typedef.rep(addCk(readPot(eid), amount)));
    sstore(totalSlot(), Typedef.rep(addCk(readTotal(), amount)));
    solAssert(balanceSelf() >= readTotal());
}

// Value leaves the pot: debit both ledgers FIRST (checked subs - a debit the
// pot cannot cover is a Panic 0x11, though flows pre-check their own
// friendlier errors), then transfer, then assert the invariant - the CEI
// order, structural instead of remembered.
function payOut(eid: uint256, dst: address, amount: uint256) {
    sstore(potSlot(eid), Typedef.rep(subCk(readPot(eid), amount)));
    sstore(totalSlot(), Typedef.rep(subCk(readTotal(), amount)));
    sendValue(dst, amount);
    solAssert(balanceSelf() >= readTotal());
}

// --- module-private transfer (weth9 pattern) ---
// Deliberately NOT exported: every ETH egress goes through payOut above.

function sendValue(dst: address, wad: uint256) {
    let ret = call(gas(), Typedef.rep(dst), Typedef.rep(wad), 0, 0, 0, 0);
    requireK(ret != 0, "TransferFailed()");
}
