#!/usr/bin/env bash
# Deploy the Core Solidity Kodyl contract to a public testnet (Sepolia,
# chain id 11155111, is the target) and write a committable deployment record
# under deployments/<chainid>.json.
#
# Everything is env-driven - no positional args, and in particular NO key on
# argv (argv leaks into shell history and ps):
#
#   RPC_URL           required; the node to deploy through
#   EXPECTED_CHAIN_ID required; asserted against the node before anything else
#   MAINTAINER        required; the dust recipient (constructor arg), non-zero
#   ACCOUNT           signer option 1: a cast keystore account name
#                     (cast prompts for the password, or set ETH_PASSWORD).
#                     Preferred: the key never appears on any process argv.
#   PRIVATE_KEY       signer option 2: a raw hex key. Caveat: the script
#                     passes it to cast via --private-key, so it is visible
#                     in ps for the duration of the cast call - use the
#                     keystore option on shared machines
#
# Chain id 1 (mainnet) is refused unconditionally: this contract is a
# research-language showcase, not a deployment target (see README Status).
#
# Usage:
#   RPC_URL=https://... EXPECTED_CHAIN_ID=11155111 MAINTAINER=0x... \
#       ACCOUNT=sepolia-deployer scripts/deploy-testnet.sh
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
HEX="$ROOT/core/build/Kodyl.hex"

: "${RPC_URL:?set RPC_URL - there is no default for real networks}"
: "${EXPECTED_CHAIN_ID:?set EXPECTED_CHAIN_ID (11155111 for Sepolia) - it is asserted against the node}"
: "${MAINTAINER:?set MAINTAINER - the dust recipient passed to the constructor}"

# Exactly one signer source.
if [ -n "${ACCOUNT:-}" ] && [ -n "${PRIVATE_KEY:-}" ]; then
    echo "error: set either ACCOUNT or PRIVATE_KEY, not both" >&2
    exit 1
elif [ -n "${ACCOUNT:-}" ]; then
    SIGNER=(--account "$ACCOUNT")
elif [ -n "${PRIVATE_KEY:-}" ]; then
    SIGNER=(--private-key "$PRIVATE_KEY")
else
    echo "error: set ACCOUNT (cast keystore name) or PRIVATE_KEY to sign" >&2
    exit 1
fi

# Chain checks BEFORE anything signs: mainnet is refused no matter what the
# operator claims to expect, and the node must be the chain they claimed.
CHAINID="$(cast chain-id --rpc-url "$RPC_URL")"
if [ "$CHAINID" = "1" ]; then
    echo "error: $RPC_URL is Ethereum mainnet (chain id 1); this script never deploys there" >&2
    exit 1
fi
if [ "$CHAINID" != "$EXPECTED_CHAIN_ID" ]; then
    echo "error: node reports chain id $CHAINID but EXPECTED_CHAIN_ID=$EXPECTED_CHAIN_ID" >&2
    exit 1
fi

# Maintainer sanity: must parse as an address and must not be zero (dust sent
# to address(0) would burn; the constructor rejects it anyway - fail earlier).
MAINTAINER="$(cast to-check-sum-address "$MAINTAINER")"
if [ "$MAINTAINER" = "0x0000000000000000000000000000000000000000" ]; then
    echo "error: MAINTAINER is the zero address" >&2
    exit 1
fi

if [ ! -f "$HEX" ]; then
    echo "Compiling core contracts first..."
    "$ROOT/scripts/check-core.sh" "$ROOT/core/Kodyl.solc"
fi

# Deploy exactly like deploy-anvil.sh: pipeline hex initcode with the
# ABI-encoded constructor arg appended, as Solidity does.
echo "Deploying Kodyl to chain $CHAINID via $RPC_URL (maintainer=$MAINTAINER)"
INIT="$(cat "$HEX")"
CTOR="$(cast abi-encode 'c(address)' "$MAINTAINER")"
RECEIPT="$(cast send --rpc-url "$RPC_URL" "${SIGNER[@]}" --create "0x${INIT}${CTOR#0x}" --json)"
ADDR="$(echo "$RECEIPT" | jq -r .contractAddress)"
DEPLOY_BLOCK="$(printf '%d' "$(echo "$RECEIPT" | jq -r .blockNumber)")"

echo "  deployed at:  $ADDR"
echo "  deploy block: $DEPLOY_BLOCK"
echo "  code on-chain: $(cast codesize --rpc-url "$RPC_URL" "$ADDR") bytes"

# The deployment record. This one is MEANT to be committed: it superset-matches
# the frontend's deployment.json shape and adds what a third party needs to
# verify the deployment (initcode hash, toolchain rev).
mkdir -p "$ROOT/deployments"
REC="$ROOT/deployments/$CHAINID.json"
cat > "$REC" <<EOF
{
  "address": "$ADDR",
  "chainId": $CHAINID,
  "rpcUrl": "$RPC_URL",
  "deployBlock": $DEPLOY_BLOCK,
  "initcodeSha256": "$(sha256sum "$HEX" | cut -d' ' -f1)",
  "solcoreRev": "$(awk '/^solcore_rev/{print $2}' "$ROOT/core/build/TOOLCHAIN")",
  "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
}
EOF
echo "  wrote deployments/$CHAINID.json (commit this record)"

echo
echo "Next steps:"
echo "  cp deployments/$CHAINID.json frontend/src/deployment.json   # point the frontend at it"
echo "  (demo affordances are chain-gated to 31337 and turn off automatically off-local)"
echo "  if RPC_URL embeds an API key, edit rpcUrl to a public endpoint before committing"
