#!/usr/bin/env bash
# Deploy the Core Solidity Kodyl contract to a running node (anvil by default)
# and record the address for the frontend.
#
# The contract's initcode comes from the pipeline (scripts/check-core.sh);
# constructor args are ABI-encoded and appended, exactly as Solidity does.
#
# Usage: scripts/deploy-anvil.sh [RPC_URL] [DEPLOYER_KEY] [MAINTAINER]
set -euo pipefail

RPC="${1:-http://localhost:8545}"
# anvil account 0 (well-known dev key; NEVER use on a real network). Track
# whether the caller supplied a key: the default is only safe on local anvil.
KEY_DEFAULTED=0
if [ -z "${2:-}" ]; then KEY_DEFAULTED=1; fi
KEY="${2:-0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80}"
MAINTAINER="${3:-0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266}"

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
HEX="$ROOT/core/build/Kodyl.hex"

# Read the chain id BEFORE sending anything: the bundled dev key must never
# sign on a real network. Real networks go through scripts/deploy-testnet.sh.
CHAINID="$(cast chain-id --rpc-url "$RPC")"
if [ "$KEY_DEFAULTED" -eq 1 ] && [ "$CHAINID" != "31337" ]; then
    echo "error: no DEPLOYER_KEY given and $RPC reports chain id $CHAINID (not anvil's 31337)" >&2
    echo "       refusing to sign with the well-known anvil dev key off-local" >&2
    echo "       for a real network, use scripts/deploy-testnet.sh" >&2
    exit 1
fi

if [ ! -f "$HEX" ]; then
    echo "Compiling core contracts first..."
    "$ROOT/scripts/check-core.sh" "$ROOT/core/Kodyl.sol"
fi

echo "Deploying Kodyl to $RPC (maintainer=$MAINTAINER)"
INIT="$(cat "$HEX")"
CTOR="$(cast abi-encode 'c(address)' "$MAINTAINER")"
RECEIPT="$(cast send --rpc-url "$RPC" --private-key "$KEY" --create "0x${INIT}${CTOR#0x}" --json)"
ADDR="$(echo "$RECEIPT" | jq -r .contractAddress)"
# Receipt blockNumber is hex; the frontend wants a decimal log-scan floor.
DEPLOY_BLOCK="$(printf '%d' "$(echo "$RECEIPT" | jq -r .blockNumber)")"

echo "  deployed at:  $ADDR"
echo "  chain id:     $CHAINID"
echo "  deploy block: $DEPLOY_BLOCK"
echo "  code on-chain: $(cast codesize --rpc-url "$RPC" "$ADDR") bytes"

mkdir -p "$ROOT/frontend/src"
RECORD="{
  \"address\": \"$ADDR\",
  \"chainId\": $CHAINID,
  \"rpcUrl\": \"$RPC\",
  \"deployBlock\": $DEPLOY_BLOCK
}"
OUT="$ROOT/frontend/src/deployment.json"
# Skip the write when nothing changed so a redeploy that lands on the same
# address (fresh anvil is deterministic) does not dirty the working tree.
if [ -f "$OUT" ] && [ "$RECORD" = "$(cat "$OUT")" ]; then
    echo "  frontend/src/deployment.json already up to date"
else
    printf '%s\n' "$RECORD" > "$OUT"
    echo "  wrote frontend/src/deployment.json"
fi
