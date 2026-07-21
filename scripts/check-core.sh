#!/usr/bin/env bash
# Compile Core Solidity sources in core/ to deployable bytecode.
#
# Pipeline per contract: sol-core (.solc -> .hull) -> yule (.hull -> .yul)
#                        -> solc --strict-assembly (.yul -> hex initcode)
#
# Toolchain is pinned to the solcore checkout the installed sol-core was built
# from (rev 1d490d8b, ~/temp_dev/solcore). Rebuilding one without the other can
# skew silently - keep them in sync.
set -euo pipefail

SOL_CORE="$HOME/.nix-profile/bin/sol-core"
YULE="$HOME/.nix-profile/bin/yule"
SOLC="/nix/store/zg76r3laqp07wydv8g4pbhdqp8dx4h88-solc-0.8.28/bin/solc"
STD="$HOME/temp_dev/solcore/std"

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
CORE="$ROOT/core"
BUILD="$CORE/build"
mkdir -p "$BUILD"

files=("$@")
if [ ${#files[@]} -eq 0 ]; then
    files=("$CORE"/*.solc)
fi

for f in "${files[@]}"; do
    base="$(basename "$f" .solc)"
    # Shared modules (no contract declaration) are compiled via their importers.
    if ! rg -q '^contract ' "$f"; then
        echo "== $base (module, skipped)"
        continue
    fi
    echo "== $base"
    # sol-core always names its output output1.hull (output2... for further
    # contracts in the same file); we compile one contract per file and rename.
    rm -f "$BUILD"/output*.hull
    # No --abi: its JSON emitter cannot represent DynArray returns
    # (getAllEvents). Selector compatibility is proven by the forge suite,
    # which calls the ported bytecode through the Solidity interfaces.
    "$SOL_CORE" -f "$f" --root "$CORE" -i "$STD" -o "$BUILD"
    mv "$BUILD/output1.hull" "$BUILD/$base.hull"
    "$YULE" "$BUILD/$base.hull" -o "$BUILD/$base.yul"
    # Extraction idiom from the solcore harness (contest.sh:118).
    "$SOLC" --strict-assembly --bin --optimize "$BUILD/$base.yul" \
        | tail -1 | tr -d '\n' > "$BUILD/$base.hex"
    echo "   -> $BUILD/$base.hex ($(wc -c < "$BUILD/$base.hex") hex chars)"
done
