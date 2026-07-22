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
# anvil account 0 (well-known dev key; NEVER use on a real network).
KEY="${2:-0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80}"
MAINTAINER="${3:-0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266}"

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
HEX="$ROOT/core/build/Kodyl.hex"

if [ ! -f "$HEX" ]; then
    echo "Compiling core contracts first..."
    "$ROOT/scripts/check-core.sh" "$ROOT/core/Kodyl.solc"
fi

echo "Deploying Kodyl to $RPC (maintainer=$MAINTAINER)"
INIT="$(cat "$HEX")"
CTOR="$(cast abi-encode 'c(address)' "$MAINTAINER")"
RECEIPT="$(cast send --rpc-url "$RPC" --private-key "$KEY" --create "0x${INIT}${CTOR#0x}" --json)"
ADDR="$(echo "$RECEIPT" | jq -r .contractAddress)"
CHAINID="$(cast chain-id --rpc-url "$RPC")"

echo "  deployed at:  $ADDR"
echo "  chain id:     $CHAINID"
echo "  code on-chain: $(( ${#ADDR} > 0 ? $(cast code --rpc-url "$RPC" "$ADDR" | wc -c) / 2 : 0 )) bytes"

mkdir -p "$ROOT/frontend/src"
cat > "$ROOT/frontend/src/deployment.json" <<EOF
{
  "address": "$ADDR",
  "chainId": $CHAINID,
  "rpcUrl": "$RPC"
}
EOF
echo "  wrote frontend/src/deployment.json"
