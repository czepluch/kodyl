# Kodyl demo frontend

A local-testnet UI for the Core Solidity `Kodyl` contract (`core/Kodyl.solc`),
structured around the roles the contract actually has. React + viem talking to
anvil. See `ROLES-PLAN.md` for the design rationale.

## Roles, not "admin"

Kodyl is permissionless - anyone who calls `createEvent` becomes the organizer
of that event; the only protocol role is the maintainer (dust). So the UI is
three lenses on the same data:

- **Discover** (`/`) - browse open events and register.
- **My tickets** (`/me`) - events you're registered for, grouped by what needs
  doing.
- **Organize** (`/organize`) - create events and manage the ones you run
  (organizer controls appear contextually on each event page).
- **Event page** (`/event/:id`) - full detail + the attendee roster,
  reconstructed from event logs (the contract has no on-chain attendee list).

## Identity: demo accounts or a real wallet

Toggle in the top-right:
- **Demo accounts** (default) - impersonate anvil's unlocked accounts, no wallet
  setup. Best for talks.
- **Connect wallet** - a real injected wallet (MetaMask) via viem's
  `custom(window.ethereum)` transport. Point MetaMask at the anvil RPC and
  import an anvil key to try it.

## Metadata

Events carry structured metadata (name, description, location) encoded into an
on-chain `data:` URI when you create them. `metadata.ts`'s `resolveMetadata`
also understands `http(s)` and `ipfs://`, so moving to real hosting later is a
one-function change. Events created without structured metadata (e.g. the
seed's `ipfs://...`) show the raw URI as their title.

## Demo controls

The chain-clock fast-forward and the account impersonator live in a **Demo
controls** drawer (right edge) - dev affordances kept out of the main UX. Kodyl
state is timestamp-derived, so fast-forwarding walks an event
Registration -> Active -> Dispute -> Settled in seconds (anvil's
`evm_setNextBlockTimestamp`).

## Run it

From the repo root, with the Foundry toolchain on PATH:

```bash
./scripts/check-core.sh core/Kodyl.solc   # compile to bytecode
anvil                                      # local node (leave running)
./scripts/deploy-anvil.sh                  # deploy; writes src/deployment.json
./scripts/seed-anvil.sh                    # a couple of demo events
node mailbox/server.mjs                     # voucher relay for proof check-in (leave running)
cd frontend && npm install && npm run dev  # http://localhost:5173
```

The mailbox is optional (its URL is `VITE_MAILBOX_URL`, default
`http://localhost:8787`): without it the door's outbox and direct submission
still work, only attendee self-rescue needs it.

## Proof-based check-in (tickets, door, self-rescue)

The door is decoupled from the on-chain write by two EIP-712 signatures (see
`spec.md` for the protocol). The click-path, all on local anvil:

1. **Attendee** (demo account 1): register for an event, then **Show ticket** -
   signs a `Ticket` once (cached in `localStorage`) and renders it as a QR code
   and copyable JSON.
2. **Organizer** (account 0): on the event page, open the check-in **Door** tab,
   **Scan** the QR (or paste the JSON). The app verifies the ticket signer with
   `recoverTypedDataAddress` and the roster status, then you **countersign**
   `Presence`. **Submit N on-chain** sends `checkInWithProof` (one)
   or `checkInBatchWithProofs` (several); the roster flips to CheckedIn.
3. **Reminder banner + self-rescue**: a warning banner at the top of My
   tickets (per event) and on the event page warns a registered attendee whose
   check-in is not on-chain yet. If the door countersigned but never
   submitted, the banner carries **Confirm check-in on-chain** (the voucher
   arrived via the mailbox) so the attendee submits it themselves - during the
   event or the dispute window; if the event has ended with no voucher, it
   says to contact the organizer before the dispute window closes. (While the
   event is running and no voucher exists it stays quiet - showing the ticket
   at the door is the normal path.) A proof has no expiry of its own - it
   submits any time until the dispute window closes check-in
   (`CheckInWindowClosed` on-chain after that, decoded by the FRIENDLY error
   map).

The on-chain and mailbox layers of this flow are covered by an automated check,
`scripts/verify-proof-e2e.mjs`: viem signs with the exact `eip712.ts`
domain/types and the deployed contract accepts the pair (relayer-submitted and
operator-signed batch), rejects wrong-signer / wrong-domain, closes at the
dispute-window edge (`CheckInWindowClosed`), and the
mailbox roundtrips. Run it from `frontend/` against a running anvil + deploy
(and optionally the mailbox): `node scripts/verify-proof-e2e.mjs`. The UI
click-path above is the manual half.

## Structure

| File | Role |
|---|---|
| `config.ts` | chain, clients, anvil dev accounts, ABI, label tables, `MAILBOX_URL` |
| `session.ts` | identity + signing (demo / wallet), `sendTx`, `signTypedData` |
| `eip712.ts` | EIP-712 domain + Ticket/Presence type objects (byte-match the contract) |
| `outbox.ts` | `localStorage` ticket cache + operator outbox |
| `mailbox.ts` | voucher relay client (`postVoucher` / `fetchVoucher`) |
| `qr.tsx` | QR generation (`qrcode`) and camera scanning (`jsqr`) |
| `useKodyl.ts` | per-event state via a viem public client, block-watched |
| `logs.ts` | roster + activity reconstructed from event logs |
| `metadata.ts` | `EventMeta`, `encodeMetadata`, `resolveMetadata` |
| `router.ts` | tiny hash router |
| `ctx.ts` | shared app context (data + tx runner) |
| `components.tsx` | nav, identity bar, event card/actions, ticket + Door, check-in reminder banner (self-rescue), demo drawer |
| `views.tsx` | Discover / Event / My tickets / Organize |
| `App.tsx` | shell: providers, layout, route switch, activity feed |

## Notes

- `src/kodylAbi.json` is generated by `scripts/sync-abi.sh` (repo root) from
  `test/KodylAbi.sol` - regenerate it there, never edit it by hand.
- Reads refresh on each new block (state only changes when a block is mined),
  with JSON-RPC batching so a tick is one HTTP request.
- The dev keys in `config.ts` are anvil's well-known ones. Local demo only.
- Chain gating: the demo accounts, the chain-clock controls, and the demo
  drawer appear only when `deployment.json` records chain id 31337 (local
  anvil). On any other chain the app is wallet-only and `walletFor` refuses to
  build a dev-key signer.
- `npm run dev` (esbuild) skips the typecheck; `npm run build` runs `tsc`
  strictly and passes clean.
