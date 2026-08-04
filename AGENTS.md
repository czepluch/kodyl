# Kodyl - agent guidelines

## What this is

Kodyl implemented in **Core Solidity** (`.solc`, the solcore research language).
Event-deposit protocol: stake to register, checked-in attendees reclaim their
deposit plus a pro-rata share of no-show forfeitures, dust to a maintainer. See
`spec.md` for the concept and `core/README.md` for the design + deviations.
There is **no classic-Solidity version** in this repo, and we don't
want one - the point is the Core Solidity implementation.

## Architecture

A **singleton**: one `Kodyl` contract holds every event. An event is a
payload-carrying ADT (`data EventRec = NoEvent | Ev(...)`) stored in a mapping
keyed by a sequential id; `createEvent` is a state write, not a deployment.
Attendee status is a nested mapping; lifecycle state is derived from timestamps
and matched on. Per-event tallies live in one positional product value
(`data Counters = Counters(...)`: registered, checkedIn, claimed, held) behind
the event id. Custody is shared: one contract balance, tracked by a per-event
pot (the `held` field of `Counters`) and a global ledger (`totalHeld`).

Check-in has two paths. The **direct** path (`checkIn`, `checkInBatch`) is an
organizer transaction. The **proof-based** path (v2) decouples the door from
the write: an attendee signs an EIP-712 `Ticket(uint256 eventId)`, the
organizer or an authorized operator signs `Presence(uint256 eventId,address
attendee)`, and anyone submits the pair via
`checkInWithProof` / `checkInBatchWithProofs` while check-in is open - a
`Presence` has no expiry of its own; the dispute-window state gate
(`requireCheckInOpen`) is the only time bound.
Operators are a nested-mapping set (slot 8), organizer-only, managed by
`addOperator`/`removeOperator` (a pair, not `setOperator(...,bool)` - no `bool`
calldata decoder) and read by `isOperator`. Signature recovery goes through
`recoverStrict` in `lib.kodyl` (zeroes scratch before `ecrecover`; see its
comment). The `mailbox/` service is a zero-dependency relay that carries the
operator's signed `Presence` to a stranded attendee for self-rescue - trust-free,
since the contract verifies both signatures.

Core files:
- `core/Kodyl.solc` - the contract.
- `core/kodyl.solc` - shared module (`import lib.kodyl.{*}`): checked-math
  shims, revert/event builders, env wrappers, validation, EIP-712 env
  wrappers (`chainId`/`self`), and `recoverStrict`. This is the
  "infrastructure the language doesn't have yet" layer. (The `Sig` split +
  `splitSig` live in `Kodyl.solc`, not here: matching a constructor imported
  from another module fails `SC0107`, so the ADT lives with its match sites.)
- `core/Probe.solc` - toolchain canary.
- `mailbox/server.mjs` - the voucher relay (plain Node, no deps).
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
and stamps every build into `core/build/TOOLCHAIN`. The build outputs that
matter (`core/build/*.hex`, `*.yul`, `TOOLCHAIN`) are **committed** so a
fresh clone can `forge test` without the toolchain; `*.hull`/`*.abi`
intermediates stay local. **Do not modify the solcore repo.** After
editing a `.solc` file, always `check-core.sh` then `forge test` - the tests
assert selectors, event topics, and revert payloads byte-for-byte, so a
hand-rolled encoding mistake surfaces immediately - and commit the changed
`core/build` artifacts with the source change.

CI (`.github/workflows/ci.yml`) runs three verification jobs behind a
change-detection gate job: `forge-test` (the suite plus
the frontend-ABI drift check), `frontend` (npm build, on frontend changes),
and `reproduce-core` (rebuilds `core/build` from source at the pinned solcore
rev and fails unless the committed hex/yul are byte-identical - see
`VERIFICATION.md`).

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
- **No `receive`** - handled in the `payable fallback` (empty calldata rejects
  ETH). Lazy calldata dynamic-array decoding (`calldata(array(T))` params,
  `arr[i]`/`arr.length()`) landed at the `1950e707` re-pin - the memory-array
  decoder is still a stub, so array params must be spelled `calldata(...)`.
  `checkInBatch` REMAINS hand-decoded in the fallback deliberately: wire
  compat, the stray-ETH rejection lives there, and it is the historical
  exhibit. Do not migrate it.
- **String literals** materialize at runtime, but the native `require(cond,
  "msg")` revert is raw bytes, not Solidity `Error(string)` - so reason
  strings live in source and go through `revertStr`, which builds the
  Solidity wire shape by hand. The constructor keeps one precomputed packed
  word (literals do not materialize in deploy code).
- **`match` has no guards** - condition-in-arm isn't supported; match the shape,
  then `if` inside the arm.
- **Errors**: sites read `fail("X()")` / `requireK(cond, "X()")` - the
  `ErrSel` `Str` instance folds signature literals to selectors at compile
  time; errors with args are hand-built payloads matching
  `abi.encodeWithSelector` (`revertWith2`, `revertStr`).
- **No named constants** - protocol constants are nullary functions in
  `lib.kodyl` (`maxBatchSize()` etc.), the single source for internal guards
  and the public getters alike.
- Zero `assembly` blocks in our code - every opcode is an imported typed
  function.

## Frontend

`frontend/` is a React + viem demo (roles: Discover / My tickets / Organize).
`frontend/src/kodylAbi.json` is generated from `test/KodylAbi.sol` by
`scripts/sync-abi.sh` (`--check` verifies it is current). See
`frontend/README.md`.

## Networks

- **Local anvil**: `scripts/deploy-anvil.sh` (guarded: with the defaulted dev
  key it refuses any chain id other than 31337). Ephemeral; writes
  `frontend/src/deployment.json` directly, never a `deployments/` record.
- **Sepolia (or another testnet)**: `scripts/deploy-testnet.sh` only.
  Env-based signer - `ACCOUNT` (cast keystore) or `PRIVATE_KEY` env, never
  argv; `EXPECTED_CHAIN_ID` is asserted against the node; mainnet (chain id
  1) is hard-refused regardless. Do not weaken any of these guards.
- **Records**: each live deployment writes `deployments/<chainid>.json`
  (address, chainId, rpcUrl, deployBlock, initcodeSha256, solcoreRev,
  timestamp) - these are committed. The frontend follows
  `frontend/src/deployment.json`: point it at a network by copying the
  record there (`cp deployments/<chainid>.json frontend/src/deployment.json`).
- Demo affordances (dev-key session picker, fast-forward) are chain-gated off
  outside 31337; the bundled anvil dev keys must stay unreachable off-local.

Mainnet is out of scope: Core Solidity is a research language, not
production-ready.
