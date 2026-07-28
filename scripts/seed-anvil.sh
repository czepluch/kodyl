#!/usr/bin/env bash
# Seed a deployed Kodyl contract with demo data so the frontend has something
# to show on first load: two Registration-stage events with a few anvil
# accounts registered. Lifecycle progression (Active/Dispute/Settled) comes
# from advancing anvil's clock afterwards - use the frontend demo drawer's
# fast-forward, or the cast rpc tip printed at the end.
#
# Usage: scripts/seed-anvil.sh [RPC_URL]
#   Reads the deployed address from frontend/src/deployment.json.
set -euo pipefail

RPC="${1:-http://localhost:8545}"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
ADDR="$(jq -r .address "$ROOT/frontend/src/deployment.json")"

# anvil default accounts (dev keys - never real funds).
K0=0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80  # organizer
K1=0x59c6995e998f97a5a0044966f0945389dc9e86dae88c7a8412f4603b6b78690d
K2=0x5de4111afa1a4b94908f83103eb1f1706367c2e68ca870fc3fb9a804cdab365a
K3=0x7c852118294e51e653712a81e05800f419141751be58f605c371e15141b007a6
A1=0x70997970C51812dc3A010C7d01b50e0d17dc79C8
A2=0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC
A3=0x90F79bf6EB2c4f870365E785982E1f101E93b906

DEP=1000000000000000000 # 1 ETH
NOW="$(cast block latest --rpc-url "$RPC" -f timestamp)"
send() { cast send --rpc-url "$RPC" --private-key "$1" "$ADDR" "${@:2}" --json | jq -r '.status' >/dev/null; }
# The id the contract just assigned: eventCount is sequential, so reading it
# right after createEvent is robust to pre-existing events and reruns.
lastEventId() { cast call --rpc-url "$RPC" "$ADDR" 'eventCount()(uint256)' | awk '{print $1}'; }

echo "Seeding $ADDR"

# Event A: open for registration (starts in 30 days), a couple already signed up.
S1=$((NOW + 2592000)); D1=$((S1 - 604800)); E1=$((S1 + 86400))
send "$K0" 'createEvent(uint256,uint256,uint256,uint256,uint256,uint256,string)' \
    "$DEP" "$D1" "$S1" "$E1" 86400 0 "ipfs://devcon-workshop"
EID_A="$(lastEventId)"
send "$K1" 'register(uint256)' "$EID_A" --value "$DEP"
send "$K2" 'register(uint256)' "$EID_A" --value "$DEP"
echo "  event $EID_A: Registration, 2 attendees"

# Event B: capacity-limited (max 3), one seat taken.
S2=$((NOW + 5184000)); D2=$((S2 - 604800)); E2=$((S2 + 86400))
send "$K0" 'createEvent(uint256,uint256,uint256,uint256,uint256,uint256,string)' \
    "$DEP" "$D2" "$S2" "$E2" 86400 3 "ipfs://capped-meetup"
EID_B="$(lastEventId)"
send "$K3" 'register(uint256)' "$EID_B" --value "$DEP"
echo "  event $EID_B: Registration (cap 3), 1 attendee"

echo "Seed complete. Attendees: $A1 $A2 $A3 | organizer/maintainer: account 0"
echo "Tip: fast-forward an event's clock with"
echo "  cast rpc --rpc-url $RPC evm_setNextBlockTimestamp <ts> && cast rpc --rpc-url $RPC evm_mine"
