#!/usr/bin/env bash
# Regenerate frontend/src/kodylAbi.json from test/KodylAbi.sol, the single
# hand-authored source of the complete ABI (functions, events, and errors -
# the sol-core compiler emits functions only, so the interface carries the
# rest and `forge inspect` turns it into JSON; checkInBatch is modeled as a
# typed function even though the contract dispatches it in the fallback).
#
# Usage: scripts/sync-abi.sh          # regenerate frontend/src/kodylAbi.json
#        scripts/sync-abi.sh --check  # diff committed file against fresh
#                                     # output; nonzero exit on drift
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
OUT="$ROOT/frontend/src/kodylAbi.json"

fresh_abi() {
    forge inspect --root "$ROOT" test/KodylAbi.sol:KodylAbi abi --json
}

if [ "${1:-}" = "--check" ]; then
    if diff -u "$OUT" <(fresh_abi); then
        echo "kodylAbi.json matches test/KodylAbi.sol"
    else
        echo "error: $OUT has drifted from test/KodylAbi.sol - run scripts/sync-abi.sh" >&2
        exit 1
    fi
else
    fresh_abi > "$OUT"
    echo "wrote $OUT"
fi
