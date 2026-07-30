# Kodyl voucher mailbox

A dumb, trust-free relay for proof-based check-in. The door operator
countersigns a `Presence` attestation offline (no signal, no gas needed at the
venue); this service carries that half to the attendee - or to a relayer - so
anyone can submit the `Ticket` + `Presence` pair on-chain within the settlement
window.

It only stores and forwards. It **cannot check anyone in**: the Kodyl contract
verifies both signatures on-chain, so a forged or garbage voucher is rejected
there and only ever wastes a row here. If this service is down, the operator's
local outbox and direct on-chain submission still work; the mailbox can fail to
deliver, never forge.

## Run

```
node mailbox/server.mjs          # listens on 127.0.0.1:8787
PORT=9000 node mailbox/server.mjs
```

Zero dependencies (plain node `http`); needs Node 18+ (developed on 24). State
is an in-memory `Map` plus a best-effort JSON snapshot to `vouchers.json` next
to `server.mjs` (gitignored): it survives restarts and nothing more.

## API

All voucher fields are strings on the wire (bigints as decimal strings, the
frontend convention). A voucher is
`{ eventId, attendee, validUntil, ticketSig, presenceSig, chainId, contract }`.
Signatures are 65-byte `0x`-prefixed hex (`r || s || v`); `attendee` and
`contract` are 20-byte hex addresses.

- `POST /vouchers` - body is a voucher JSON object. Stored under
  `chainId:contract:eventId:attendee` (last write wins - a re-scan at the door
  overwrites). `400` on any missing field or malformed hex/decimal. `200`
  `{ ok, key }` on success.
- `GET /vouchers?eventId=<id>&attendee=<addr>` - the single voucher for that
  attendee, or `404`. This is the attendee's self-rescue poll. `chainId` and
  `contract` are accepted as optional narrowing filters (the store key includes
  both; a single-deployment frontend does not need them).
- `GET /vouchers?eventId=<id>` - every voucher for the event, as a JSON array
  (the relayer / door drain view). `chainId` and `contract` narrow it too.
- `GET /health` - `{ ok: true, vouchers: <count> }`.

CORS is open (`Access-Control-Allow-Origin: *`) with an `OPTIONS` preflight, so
the Vite dev server can call it cross-origin.

## Trust model and deploy hardening

The mailbox is trust-free **for correctness**: the contract is the only
authority on who checked in. It is not hardened against **spam**. Anyone can
`POST` a well-formed but bogus voucher and consume memory and a snapshot row.

The production hardening step, deliberately not implemented here to keep the
service dependency-free, is a spam gate: before storing, recover the
`Presence` signature's signer (EIP-712 digest over
`Presence(uint256 eventId,address attendee,uint256 validUntil)`, domain name
`Kodyl` version `1`, the posted `chainId` and `contract`) and reject the
voucher unless that signer is the event organizer or an on-chain-authorized
operator (`isOperator(eventId, signer)`). That needs an ECDSA/EIP-712 library
and an RPC endpoint - a real dependency and a network call per write - so it
belongs in a deployment that has both, not in this demo relay. Even without it,
nothing a spammer stores can check a non-attendee in.

Other steps a real deployment would add (all out of scope here): rate limiting,
a bound on the store size with eviction, TLS termination, and dropping vouchers
whose `validUntil` is already in the past on read.
