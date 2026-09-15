#!/usr/bin/env bash
# Compile Core Solidity sources in core/ to deployable bytecode.
#
# Pipeline per contract: sol-core (.sol -> .hull) -> yule (.hull -> .yul)
#                        -> solc --strict-assembly (.yul -> hex initcode)
#
# The toolchain lives in toolchain/ (machine-local, gitignored): GC-rooted nix
# links for sol-core/yule/solc plus a std snapshot, all at the single solcore
# rev recorded in toolchain/SOLCORE_REV. It is (re)created by
# scripts/pin-toolchain.sh, so binaries and std move together or not at all -
# they skewed apart silently once, which is why this exists. Every path is
# env-overridable (SOL_CORE, YULE, SOLC, STD). Each run stamps the exact
# toolchain into core/build/TOOLCHAIN.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TOOLCHAIN="$ROOT/toolchain"

SOL_CORE="${SOL_CORE:-$TOOLCHAIN/sol-core/bin/sol-core}"
YULE="${YULE:-$TOOLCHAIN/sol-core/bin/yule}"
SOLC="${SOLC:-$TOOLCHAIN/solc/bin/solc}"
STD="${STD:-$TOOLCHAIN/std}"

for tool in "$SOL_CORE" "$YULE" "$SOLC"; do
    if [ ! -x "$tool" ]; then
        echo "error: $tool not found or not executable" >&2
        echo "       run scripts/pin-toolchain.sh first (see its header)" >&2
        exit 1
    fi
done
if [ ! -d "$STD" ]; then
    echo "error: std library not found at $STD (run scripts/pin-toolchain.sh)" >&2
    exit 1
fi

CORE="$ROOT/core"
BUILD="$CORE/build"
mkdir -p "$BUILD"

files=("$@")
if [ ${#files[@]} -eq 0 ]; then
    # Probe first: it is the toolchain canary, so drift fails on the small
    # labeled contract before Kodyl does.
    files=("$CORE/Probe.sol")
    for f in "$CORE"/*.sol; do
        [ "$f" = "$CORE/Probe.sol" ] || files+=("$f")
    done
fi

for f in "${files[@]}"; do
    base="$(basename "$f" .sol)"
    # Shared modules (no contract declaration) are compiled via their importers.
    if ! grep -q '^contract ' "$f"; then
        echo "== $base (module, skipped)"
        continue
    fi
    echo "== $base"
    # sol-core always names its output output1.hull (output2... for further
    # contracts in the same file); we compile one contract per file and rename.
    rm -f "$BUILD"/output*.hull
    # No --abi: the compiler's ABI emitter covers functions/constructor/
    # fallback only - the hand-rolled events and errors are invisible to it -
    # so test/KodylAbi.sol is the ABI source of truth. Selector compatibility
    # is proven by the forge suite, which drives the compiled bytecode through
    # typed Solidity interfaces.
    "$SOL_CORE" -f "$f" --root "$CORE" -i "$STD" -o "$BUILD"
    mv "$BUILD/output1.hull" "$BUILD/$base.hull"
    "$YULE" "$BUILD/$base.hull" -o "$BUILD/$base.yul"
    # Extraction idiom from the solcore harness (contest.sh).
    "$SOLC" --strict-assembly --bin --optimize "$BUILD/$base.yul" \
        | tail -1 | tr -d '\n' > "$BUILD/$base.hex"
    echo "   -> $BUILD/$base.hex ($(wc -c < "$BUILD/$base.hex") hex chars)"
done

# Stamp the exact toolchain that produced these artifacts. No timestamps, so
# reproducible rebuilds diff clean.
{
    echo "solcore_rev $(cat "$TOOLCHAIN/SOLCORE_REV" 2>/dev/null || echo unknown)"
    echo "sol_core_sha256 $(sha256sum "$SOL_CORE" | cut -d' ' -f1)"
    echo "yule_sha256 $(sha256sum "$YULE" | cut -d' ' -f1)"
    echo "solc $("$SOLC" --version | tail -1)"
    if [ "$STD" != "$TOOLCHAIN/std" ]; then
        echo "std_override $STD"
    fi
} > "$BUILD/TOOLCHAIN"
echo "== stamped $BUILD/TOOLCHAIN"
