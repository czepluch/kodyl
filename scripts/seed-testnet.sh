#!/usr/bin/env bash
# Stage demo events on a real network. Unlike anvil there is no time-warp on
# a testnet: the chain clock is the wall clock, so events must be positioned
# around the planned demo time in advance. A full lifecycle needs 3+ hours of
# lead time (the 7200 s cancellation buffer before eventStart plus the 3600 s
# minimum dispute period), which is why this script takes a DEMO_TS and works
# backwards from it.
#
# create mode (default) - run at least 3.5 h before the demo. Creates three
# events positioned relative to DEMO_TS and registers the signer for each:
#   A  Settled at demo time      (its whole lifecycle fits before DEMO_TS)
#   B  Active at demo time       (starts just before, ends after)
#   C  Registration at demo time (starts 3 days after)
# Event A still needs a check-in DURING its Active/Dispute window (later than
# creation, before DEMO_TS) or there is nothing to claim at the demo - that is
# the second mode, and create mode prints exactly when to run it.
#
# checkin mode - run inside the printed window; checks the signer in:
#   scripts/seed-testnet.sh checkin deployments/<chainid>.json <eventId>
#
# Env (same signer contract as deploy-testnet.sh - no keys on this script's
# argv; the PRIVATE_KEY option is still visible in ps during each cast call,
# so prefer the keystore on shared machines):
#   RPC_URL      required
#   ACCOUNT      signer option 1: cast keystore name (password via prompt
#                or ETH_PASSWORD)
#   PRIVATE_KEY  signer option 2: raw hex key
#   DEMO_TS      create mode: unix time of the planned demo (default now + 4 h)
#
# Usage:
#   RPC_URL=... ACCOUNT=... scripts/seed-testnet.sh [create] deployments/<chainid>.json
#   RPC_URL=... ACCOUNT=... scripts/seed-testnet.sh checkin deployments/<chainid>.json <eventId>
set -euo pipefail

MODE="create"
case "${1:-}" in
    create|checkin) MODE="$1"; shift ;;
esac
DEPLOYMENT="${1:?usage: seed-testnet.sh [create|checkin] deployments/<chainid>.json [eventId]}"

: "${RPC_URL:?set RPC_URL}"
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

ADDR="$(jq -r .address "$DEPLOYMENT")"
REC_CHAIN="$(jq -r .chainId "$DEPLOYMENT")"
CHAINID="$(cast chain-id --rpc-url "$RPC_URL")"
if [ "$CHAINID" = "1" ]; then
    echo "error: $RPC_URL is Ethereum mainnet (chain id 1); refusing" >&2
    exit 1
fi
if [ "$CHAINID" != "$REC_CHAIN" ]; then
    echo "error: node reports chain id $CHAINID but $DEPLOYMENT says $REC_CHAIN" >&2
    exit 1
fi

SIGNER_ADDR="$(cast wallet address "${SIGNER[@]}")"
send() { cast send --rpc-url "$RPC_URL" "${SIGNER[@]}" "$ADDR" "$@" --json | jq -r '.status' >/dev/null; }
call() { cast call --rpc-url "$RPC_URL" "$ADDR" "$@"; }
lastEventId() { call 'eventCount()(uint256)' | awk '{print $1}'; }
when() { date -d "@$1" '+%Y-%m-%d %H:%M %Z'; }

# ---- checkin mode ----------------------------------------------------------

if [ "$MODE" = "checkin" ]; then
    EID="${2:?usage: seed-testnet.sh checkin deployments/<chainid>.json <eventId>}"
    STATE="$(call 'getState(uint256)(uint256)' "$EID" | awk '{print $1}')"
    if [ "$STATE" != "1" ] && [ "$STATE" != "2" ]; then
        read -r _org _dep _dl START END DISPUTE _cap \
            <<<"$(call 'getEvent(uint256)(address,uint256,uint256,uint256,uint256,uint256,uint256)' "$EID" | awk '{print $1}' | tr '\n' ' ')"
        echo "error: event $EID is in state $STATE (0=Registration 3=Settled 4=Cancelled), not Active/Dispute" >&2
        echo "       its check-in window is $(when "$START") .. $(when $((END + DISPUTE)))" >&2
        exit 1
    fi
    echo "Checking $SIGNER_ADDR in to event $EID (state $STATE)"
    send 'checkIn(uint256,address)' "$EID" "$SIGNER_ADDR"
    echo "  done - attendee status now $(call 'attendees(uint256,address)(uint256)' "$EID" "$SIGNER_ADDR") (3 = CheckedIn)"
    exit 0
fi

# ---- create mode -----------------------------------------------------------

DEP=1000000000000000 # 0.001 ETH - testnet ETH is scarce, keep stakes tiny
NOW="$(cast block latest --rpc-url "$RPC_URL" -f timestamp)"
DEMO_TS="${DEMO_TS:-$((NOW + 14400))}"

# Event A's earliest possible settlement: deadline > now, start >= deadline +
# 7200, end > start, dispute >= 3600 puts end + dispute past now + 10800; the
# concrete timeline below settles at now + 12000. Require 600 s of margin.
if [ "$DEMO_TS" -lt $((NOW + 12600)) ]; then
    echo "error: DEMO_TS=$DEMO_TS is too soon - the Settled event cannot finish its lifecycle" >&2
    echo "       earliest workable demo time is $((NOW + 12600)) ($(when $((NOW + 12600))), 3.5 h from now)" >&2
    exit 1
fi

echo "Seeding $ADDR on chain $CHAINID for a demo at $(when "$DEMO_TS") (signer $SIGNER_ADDR)"

# Event A - Settled at demo time. Validation arithmetic:
#   deadline = now + 600            > now                        (deadline in future)
#   start    = now + 7800           = deadline + 7200            (buffer met exactly)
#   end      = now + 8400           > start                      (end after start)
#   dispute  = 3600                 = the allowed minimum
#   end + dispute = now + 12000     < DEMO_TS                    (Settled at demo)
DL_A=$((NOW + 600)); S_A=$((NOW + 7800)); E_A=$((NOW + 8400)); DP_A=3600
send 'createEvent(uint256,uint256,uint256,uint256,uint256,uint256,string)' \
    "$DEP" "$DL_A" "$S_A" "$E_A" "$DP_A" 0 "ipfs://kodyl-demo-settled"
EID_A="$(lastEventId)"
send 'register(uint256)' "$EID_A" --value "$DEP"
echo "  event $EID_A (Settled at demo): registered now, needs the check-in run below"

# Event B - Active at demo time: starts 10 min before, ends 2 h after.
S_B=$((DEMO_TS - 600)); DL_B=$((S_B - 7200)); E_B=$((DEMO_TS + 7200)); DP_B=3600
send 'createEvent(uint256,uint256,uint256,uint256,uint256,uint256,string)' \
    "$DEP" "$DL_B" "$S_B" "$E_B" "$DP_B" 0 "ipfs://kodyl-demo-active"
EID_B="$(lastEventId)"
send 'register(uint256)' "$EID_B" --value "$DEP"
echo "  event $EID_B (Active at demo): registered"

# Event C - still Registration at demo time: starts 3 days after the demo.
S_C=$((DEMO_TS + 259200)); DL_C=$((S_C - 86400)); E_C=$((S_C + 86400)); DP_C=86400
send 'createEvent(uint256,uint256,uint256,uint256,uint256,uint256,string)' \
    "$DEP" "$DL_C" "$S_C" "$E_C" "$DP_C" 0 "ipfs://kodyl-demo-registration"
EID_C="$(lastEventId)"
send 'register(uint256)' "$EID_C" --value "$DEP"
echo "  event $EID_C (Registration at demo): registered"

echo
echo "Timeline (all times $(date '+%Z')):"
echo "  now                          $(when "$NOW")"
echo "  event $EID_A check-in window:     $(when "$S_A") .. $(when $((E_A + DP_A)))"
echo "  event $EID_A settled from:        $(when $((E_A + DP_A)))"
echo "  demo                         $(when "$DEMO_TS")"
echo "  event $EID_B active:              $(when "$S_B") .. $(when "$E_B")"
echo "  event $EID_C starts:              $(when "$S_C")"
echo
# Never echo a raw key back; the keystore name is fine to show.
if [ -n "${ACCOUNT:-}" ]; then SIGNER_HINT="ACCOUNT=$ACCOUNT"; else SIGNER_HINT="PRIVATE_KEY=<key>"; fi
echo "ACTION REQUIRED between $(when "$S_A") and $(when $((E_A + DP_A))):"
echo "  RPC_URL=$RPC_URL $SIGNER_HINT scripts/seed-testnet.sh checkin $DEPLOYMENT $EID_A"
echo "  (skipping it leaves event $EID_A with a registered no-show and nothing to claim)"
echo "During the demo, event $EID_B accepts the same check-in live:"
echo "  RPC_URL=$RPC_URL $SIGNER_HINT scripts/seed-testnet.sh checkin $DEPLOYMENT $EID_B"
