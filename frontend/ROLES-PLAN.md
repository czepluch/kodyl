# Kodyl frontend: role-based views - design plan

Status: proposal for discussion. No code changes yet.

## 0. The reframing: there is no "admin"

Kodyl is permissionless. Anyone can call `createEvent` and thereby become the
**organizer** of *that* event - there is no global admin account. The only
protocol-level role is the **maintainer** (receives dust, set at deploy,
transferable via `setMaintainer`).

So this isn't "an admin app vs a user app." It's three **lenses on the same
events**, and one person can be in more than one at once:

- **Attendee** (everyone): discover events, register, cancel, claim, refund.
  Public, read-heavy, action-light.
- **Organizer** (per event you created): manage *your own* events - check-in,
  cancel, sweep dust, edit metadata. Contextual, not a global role.
- **Maintainer** (one address): protocol settings + dust. Minor surface.

Designing around "you are always an attendee, and *additionally* an organizer
of the events you created" matches the contract and avoids inventing a fake
admin gate. The current single-page "god mode" (switch to any account, every
control visible, time-warp buttons) is really a **demo console**, not any of
these lenses - it should become a dev affordance, not the main experience.

## 1. Information architecture

Attendee-first; organizer surfaces are additive and only appear when relevant.

| Route | View | Audience | Shows | Actions |
|---|---|---|---|---|
| `/` | Discover | attendee | open (Registration-state) events: name, when, deposit, spots left, register-by | Register |
| `/event/:id` | Event page | attendee | full details, state + countdown, your status, roster (optional) | Register / Cancel / Claim / Refund |
| `/me` | My tickets | attendee | events where I have a status, grouped: upcoming / to-claim / past | contextual per event |
| `/organize` | Organizer dashboard | organizer | events I created + the create form | Create event |
| `/organize/:id` | Manage event | organizer | roster with check-in, event controls | Check-in (single/batch), Cancel event, Sweep dust, Edit metadata |
| `/settings` | Maintainer | maintainer only | dust overview, maintainer address | setMaintainer |

Nav shell: top bar with **Discover / My tickets / Organize**, connected identity
on the right. Organizer/maintainer items appear based on whether the connected
address organizes anything (from `EventCreated` logs) or equals `maintainer()`.

## 2. Identity / wallet (the real decision)

Today the app impersonates anvil's accounts via a dropdown - excellent for a
talk, but not "user-facing." A real user experience needs a connected wallet:
your address = "you." This is exactly where wagmi's connectors (which we
currently bypass) earn their keep.

- **A. Real wallet connect** (wagmi injected / WalletConnect). Authentic; adds
  the connector deps (the noisy ones). For a demo you import an anvil key into
  MetaMask pointed at localhost.
- **B. Keep impersonation**, moved into a "Demo mode" account picker. Zero
  friction for demos, not real.
- **C. Both, via a mode toggle.** Default "Demo accounts" (current behavior) for
  talks; "Connect wallet" for the real experience. `me` is already a single
  abstraction - only where the account + signer come from changes.

Recommendation: **C**. The impersonation is the best DevRel affordance and worth
keeping; add a real connect path so the same UI works with a real wallet. The
`me` / `send` layer is untouched; only the account source swaps.

## 3. Metadata (the biggest user-facing gap)

An attendee view needs a **name, description, when/where, maybe an image** - not
`ipfs://my-event`. The contract stores a single `metadataURI` string by design.
So define a metadata JSON schema the URI resolves to:

```json
{ "name": "...", "description": "...", "location": "...", "image": "..." }
```

(The event time/deposit/capacity stay on-chain and authoritative; metadata is
display-only.)

Resolution options for the demo:

- **A. `data:` URI** - create-event encodes the JSON into
  `data:application/json;base64,...` stored on-chain. Self-contained, no hosting,
  works offline; URIs get long. Best for a demo.
- **B. Static JSON** served by vite (`public/metadata/*.json`); simple but not
  how mainnet works.
- **C. Real IPFS** - correct, needs pinning; Phase 2+.

Recommendation: **A** for the demo, behind a single `resolveMetadata(uri)` seam
so swapping to IPFS later is a one-function change. The create form grows
name/description/location fields. Fallback for events without structured
metadata (e.g. the seed's `ipfs://...`): render the raw string as the title,
the rest "-".

## 4. Tech / routing / reuse

- **Routing**: 6 routes with params pushes past a hand-rolled hash router's
  comfort. Either (a) extend the current no-dep hash router with a tiny pattern
  matcher (~40 lines, zero deps) or (b) adopt `react-router` (one dep, clean
  nested routes). Given the dep-aversion, lean (a), with (b) an easy upgrade.
- **Reuse - this is mostly reorganization, not a rewrite.** `useKodyl`,
  `logs.ts` (roster + activity; "my events" is just the same logs filtered on
  the indexed `attendee` topic), `EventActions`, `format.ts` all carry over. The
  work is routing + filtering + which controls render in which view.
- **Demo controls drawer**: move the time-warp buttons and the account switcher
  into a collapsible "Demo controls" panel (toggle via env flag or a corner
  button) so the main views read like a product while keeping the talk
  affordances.
- **Cheap data**: `/me` = existing event list filtered by `myStatus != None`
  (+ log history on my `attendee` topic); `/organize` = events where
  `organizer == me`. Both are filters over data we already load.

## 5. Phasing

**Phase 1 - role-based restructure (cheap, biggest UX win).** Nav shell +
routes; Discover, public Event page, My tickets, Organizer dashboard + Manage;
demo controls into a drawer. Reuses all existing data/logic. No new deps, no
wallet change, no metadata change (raw URI as title). ~one focused session.

**Phase 2 - make it feel real.** Metadata schema + `data:` URI create flow +
`resolveMetadata` rendering; optional real wallet connect; per-view
empty/loading/error states. Starts to be an actual app.

**Phase 3 - product polish (beyond demo).** Real IPFS metadata,
responsive/mobile, search/filters, share links, maybe a thin indexer if
log-scanning gets slow, calendar export.

## 6. Decisions (locked 2026-07-22)

1. **Wallet**: BOTH, via a mode toggle. Demo-account picker + real connect. The
   connect path uses viem's `custom(window.ethereum)` transport directly (no
   wagmi connector deps).
2. **Metadata**: structured JSON in an on-chain `data:` URI now, behind a
   `resolveMetadata(uri)` seam that also handles http/ipfs for later.
3. **Routing**: tiny no-dep hash router. Swap to react-router later if the tree
   grows.
4. **Scope**: role views + metadata (this pass).
5. **Demo controls**: dev-only drawer (time-warp + demo-account picker).
6. **Direction**: this is becoming a real app.

Route tree simplified from section 1: organizer controls stay **contextual on
the event page** (shown when you organize it) rather than a separate
`/organize/:id`, so `/organize` is just "my events + create." Maintainer
controls live as a small panel on `/organize` when you are the maintainer.
Routes this pass: `/` Discover, `/event/:id` Event, `/me` My tickets,
`/organize` Organizer.
