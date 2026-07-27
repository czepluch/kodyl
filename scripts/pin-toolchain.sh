#!/usr/bin/env bash
# (Re)pin the Core Solidity toolchain into toolchain/ from a solcore checkout.
#
# Produces, under toolchain/ (machine-local, gitignored):
#   sol-core/     nix out-link (GC root) with bin/sol-core and bin/yule,
#                 built from the checkout via its flake
#   std/          snapshot of the checkout's std library at the SAME rev
#                 (git archive), so binaries and std can never skew apart
#   solc          GC-rooted link to the pinned nixpkgs solc (created once;
#                 this script only verifies it exists)
#   SOLCORE_REV   the pinned revision, read by check-core.sh for the
#                 build stamp
#
# Usage: scripts/pin-toolchain.sh [<solcore-checkout>]
#        (default checkout: $HOME/temp_dev/solcore; the rev pinned is its
#         HEAD, which must be a clean tree so build == rev == std snapshot)
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TOOLCHAIN="$ROOT/toolchain"
CHECKOUT="${1:-$HOME/temp_dev/solcore}"
NIX="${NIX:-/nix/var/nix/profiles/default/bin/nix}"

if [ ! -d "$CHECKOUT/.git" ]; then
    echo "error: $CHECKOUT is not a git checkout of solcore" >&2
    exit 1
fi
if [ -n "$(git -C "$CHECKOUT" status --porcelain)" ]; then
    echo "error: $CHECKOUT has uncommitted changes; pin refuses a dirty tree" >&2
    echo "       (the nix build would use the tree while the pin records HEAD)" >&2
    exit 1
fi
REV="$(git -C "$CHECKOUT" rev-parse HEAD)"

mkdir -p "$TOOLCHAIN"

echo "== building sol-core + yule at $REV (nix, GC-rooted out-link)"
"$NIX" build "path:$CHECKOUT#sol-core" --out-link "$TOOLCHAIN/sol-core"

echo "== snapshotting std at $REV"
rm -rf "$TOOLCHAIN/std"
git -C "$CHECKOUT" archive "$REV" std | tar -x -C "$TOOLCHAIN/"

echo "$REV" > "$TOOLCHAIN/SOLCORE_REV"

if [ ! -x "$TOOLCHAIN/solc/bin/solc" ]; then
    echo "warning: toolchain/solc missing. Create it once with:" >&2
    echo "  nix-store --add-root $TOOLCHAIN/solc --indirect -r <solc-0.8.x store path>" >&2
fi

echo "== pinned solcore $REV"
echo "   sol-core -> $(readlink -f "$TOOLCHAIN/sol-core")"
echo "   next: ./scripts/check-core.sh && forge test"
