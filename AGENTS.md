# Kodyl - agent guidelines

## What this is

Kodyl implemented in **Core Solidity** (`.solc`, the solcore research language).
Event-deposit protocol: stake to register, checked-in attendees reclaim their
deposit plus a pro-rata share of no-show forfeitures, dust to a maintainer. See
`spec.md` for the concept and `core/README.md` for the design + numbered
deviations. There is **no classic-Solidity version** in this repo, and we don't
want one - the point is the Core Solidity implementation.

## Architecture

A **singleton**: one `Kodyl` contract holds every event. An event is a
payload-carrying ADT (`data EventRec = NoEvent | Ev(...)`) stored in a mapping
keyed by a sequential id; `createEvent` is a state write, not a deployment.
Attendee status is a nested mapping; lifecycle state is derived from timestamps
and matched on. Custody is shared: one contract balance, tracked by a per-event
pot (`heldM`) and a global ledger (`totalHeld`).

Core files:
- `core/Kodyl.solc` - the contract.
- `core/kodyl.solc` - shared module (`import lib.kodyl.{*}`): checked-math
  shims, revert/event builders, env wrappers, validation. This is the
  "infrastructure the language doesn't have yet" layer.
- `core/Probe.solc` - toolchain canary.
- `test/*.sol` - Foundry harness (deploys the compiled bytecode, drives it).
- `test/KodylAbi.sol` - hand-authored interface; `forge inspect` on it produces
  the complete ABI (the compiler emits functions only, not events/errors).

## Build & test

```
./scripts/check-core.sh      # .solc -> hull -> Yul -> hex (external pipeline)
forge test                   # forge is a HARNESS only; deploys core/build/*.hex
```

The toolchain is pinned by `scripts/pin-toolchain.sh` into `toolchain/`
(gitignored): nix-built `sol-core`/`yule` as GC-rooted links, a matching `std`
snapshot, and the solcore rev in `toolchain/SOLCORE_REV` - binaries and std
move together or not at all. `check-core.sh` consumes them (env-overridable)
and stamps every build into `core/build/TOOLCHAIN`. **Do not modify the
solcore repo.** After
editing a `.solc` file, always `check-core.sh` then `forge test` - the tests
assert selectors, event topics, and revert payloads byte-for-byte, so a
hand-rolled encoding mistake surfaces immediately.

## Key invariants (test aggressively)

1. `balance >= totalHeld` after every ETH movement. The direction is `>=`, not
   `==`: forced ETH (selfdestruct / block rewards) can push the balance above
   the ledger and cannot be rejected, so `==` would permanently brick every
   flow. This bug was found in review - do not tighten it back.
2. Per-event pot conservation: each event's `held` equals its deposits minus its
   payouts. No cross-event leakage.
3. No double claims / refunds (status transitions are terminal where required).
4. Claims only after settlement; check-ins only in Active/Dispute (a cancelled
   event never opens check-in - otherwise a deposit strands).

`test/KodylAccounting.t.sol` and `test/KodylConservation.t.sol` cover the
shared-custody accounting; `test/KodylInvariant.t.sol` fuzzes the ledger.

## Core Solidity gotchas (all shimmed in core/kodyl.solc)

- **Arithmetic wraps** - no 0.8 checked semantics. Use `addCk/subCk/mulCk`
  exactly where the logic must be checked; `panic()` reproduces `Panic(...)`.
- **`&&`/`||` do not short-circuit** - both operands always evaluate. Audit
  every guard.
- **No `event`/`emit`** - events are hand-rolled `log1..log3`; topic0 via
  compile-time-folded `keccakLit("Sig(...)")`.
- **No `receive`, and dynamic-array params are a decoder stub** - both handled
  in the `payable fallback` (empty calldata rejects ETH; `checkInBatch` is
  decoded from calldata by hand).
- **String literals**: runtime materialization landed at the current pin
  (`require(cond, "msg")` works), but its revert shape is raw bytes, not
  Solidity `Error(string)`, and constructor code still cannot use literals -
  so revert reason strings remain precomputed packed words (Solidity wire
  shape, byte-asserted by the tests) until the planned builder migration.
- **`match` has no guards** - condition-in-arm isn't supported; match the shape,
  then `if` inside the arm.
- **Errors with args** are hand-built payloads matching `abi.encodeWithSelector`.
- Zero `assembly` blocks in our code - every opcode is an imported typed
  function.

## Frontend

`frontend/` is a React + viem demo (roles: Discover / My tickets / Organize).
`frontend/src/kodylAbi.json` is generated from `test/KodylAbi.sol`. See
`frontend/README.md`.

## Networks

Local `anvil` only (via `scripts/deploy-anvil.sh`). Not deployed anywhere; Core
Solidity is a research language, not production-ready.
