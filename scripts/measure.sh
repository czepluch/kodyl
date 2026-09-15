#!/usr/bin/env bash
# Reproducible measured numbers for the docs: deployed runtime size, deploy
# gas, and gas for the hot paths, driven through a full event lifecycle on a
# scratch anvil (time-warped with evm_setNextBlockTimestamp + anvil_mine).
#
# Deploys inline with cast - NOT via deploy-anvil.sh - so nothing in the tree
# (in particular frontend/src/deployment.json) is touched. The scratch node
# dies with the script.
#
# Determinism: all protocol timestamps are offsets from T0, the next multiple
# of 2^24 seconds after now, so calldata is byte-identical between runs and
# the gas numbers are stable (T0's low three bytes are zero; the numbers can
# shift by a few gas when the 2^24 epoch rolls over, about twice a year, since
# calldata prices zero bytes cheaper).
#
# Usage: scripts/measure.sh [PORT]
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
HEX="$ROOT/core/build/Kodyl.hex"
if [ ! -f "$HEX" ]; then
    echo "Compiling core contracts first..."
    "$ROOT/scripts/check-core.sh" "$ROOT/core/Kodyl.sol"
fi

PORT="${1:-$((21000 + RANDOM % 9000))}"
RPC="http://127.0.0.1:$PORT"
MNEMONIC="test test test test test test test test test test test junk"

# Scratch node: 12 accounts (organizer + 11 attendees), killed on exit.
anvil --port "$PORT" -a 12 >/dev/null 2>&1 &
ANVIL_PID=$!
trap 'kill "$ANVIL_PID" 2>/dev/null || true' EXIT
for _ in $(seq 1 100); do
    cast chain-id --rpc-url "$RPC" >/dev/null 2>&1 && break
    sleep 0.1
done

# Anvil's deterministic dev accounts; index 0 deploys and organizes.
key() { cast wallet private-key "$MNEMONIC" "$1"; }
addr() { cast wallet address --private-key "$(key "$1")"; }
K0="$(key 0)"

dec() { case "$1" in 0x*) printf '%d' "$1" ;; *) printf '%s' "$1" ;; esac; }
warp() {
    cast rpc --rpc-url "$RPC" evm_setNextBlockTimestamp "$1" >/dev/null
    cast rpc --rpc-url "$RPC" anvil_mine >/dev/null
}
# send <key> <args...>: sends and echoes the decimal gasUsed.
send() {
    local k="$1"; shift
    local receipt
    receipt="$(cast send --rpc-url "$RPC" --private-key "$k" "$@" --json)"
    dec "$(echo "$receipt" | jq -r .gasUsed)"
}

NOW="$(cast block latest --rpc-url "$RPC" -f timestamp)"
T0=$(( ((NOW >> 24) + 1) << 24 ))
DEP=1000000000000000000 # 1 ETH

# Deploy: pipeline hex + ABI-encoded ctor arg, same idiom as the deploy scripts.
warp $((T0 + 10))
INIT="$(cat "$HEX")"
CTOR="$(cast abi-encode 'c(address)' "$(addr 0)")"
RECEIPT="$(cast send --rpc-url "$RPC" --private-key "$K0" --create "0x${INIT}${CTOR#0x}" --json)"
ADDR="$(echo "$RECEIPT" | jq -r .contractAddress)"
G_DEPLOY="$(dec "$(echo "$RECEIPT" | jq -r .gasUsed)")"
SIZE="$(cast codesize --rpc-url "$RPC" "$ADDR")"

# One event: deadline T0+700, start T0+7900 (= deadline + the 7200 s buffer),
# end T0+8500, minimum 3600 s dispute. Settled from T0+12101; dust claimable
# from T0+2604101 (+ the 30 d DUST_CLAIM_TIMEOUT).
warp $((T0 + 20))
G_CREATE="$(send "$K0" "$ADDR" 'createEvent(uint256,uint256,uint256,uint256,uint256,uint256,string)' \
    "$DEP" $((T0 + 700)) $((T0 + 7900)) $((T0 + 8500)) 3600 0 "ipfs://measure")"
EID="$(cast call --rpc-url "$RPC" "$ADDR" 'eventCount()(uint256)' | awk '{print $1}')"

# 11 attendees register; the first is the measured one (cold per-event slots).
warp $((T0 + 30))
G_REGISTER="$(send "$(key 1)" "$ADDR" 'register(uint256)' "$EID" --value "$DEP")"
for i in $(seq 2 11); do
    send "$(key "$i")" "$ADDR" 'register(uint256)' "$EID" --value "$DEP" >/dev/null
done

# Active: attendee 1 checked in singly, 2..11 as one 10-address batch.
warp $((T0 + 7910))
G_CHECKIN="$(send "$K0" "$ADDR" 'checkIn(uint256,address)' "$EID" "$(addr 1)")"
BATCH="["
for i in $(seq 2 11); do BATCH+="$(addr "$i"),"; done
BATCH="${BATCH%,}]"
G_BATCH="$(send "$K0" "$ADDR" 'checkInBatch(uint256,address[])' "$EID" "$BATCH")"

# Settled: attendee 1 claims (11 registered, 11 checked in, so payout = the
# bare deposit - no forfeiture reward in this lifecycle).
warp $((T0 + 12110))
G_CLAIM="$(send "$(key 1)" "$ADDR" 'claim(uint256)' "$EID")"

# Past the dust timeout: the 10 unclaimed deposits sweep to the maintainer.
warp $((T0 + 2604110))
G_DUST="$(send "$K0" "$ADDR" 'claimDust(uint256)' "$EID")"

echo "| Measurement | Value |"
echo "|---|---:|"
echo "| deployed runtime size | $SIZE bytes |"
echo "| deploy gas | $G_DEPLOY |"
echo "| createEvent | $G_CREATE |"
echo "| register (first attendee) | $G_REGISTER |"
echo "| checkIn (single) | $G_CHECKIN |"
echo "| checkInBatch (10 attendees) | $G_BATCH |"
echo "| claim | $G_CLAIM |"
echo "| claimDust | $G_DUST |"
echo
echo "toolchain: solcore rev $(awk '/^solcore_rev/{print $2}' "$ROOT/core/build/TOOLCHAIN")"
