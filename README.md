# Kodyl

> Event deposits with skin in the game, implemented in **Core Solidity**.

Attendees stake a deposit to register for an event. Show up and reclaim it plus
a pro-rata share of the no-shows' forfeited deposits; don't show up and you lose
your stake. Leftover rounding dust goes to a protocol maintainer. The concept is
a tribute to [Kickback](https://kickback.events/).

## What this repo is

This is a from-scratch implementation of Kodyl in
[**Core Solidity**](https://github.com/argotorg/solcore) (`.sol`), the
research language compiled by `sol-core`. It is a deliberate exercise in
building a real, non-trivial contract on the language as it exists today -
leaning into what it does well (payload-carrying ADTs as first-class storage,
exhaustive `match`, typeclass-derived encoding) and documenting where it does
not yet reach (checked arithmetic and events, both shimmed; array params must
be spelled `calldata(...)` - the hand-decoded `checkInBatch` remains as the
exhibit of the pre-decoder era).

There is no "classic Solidity" version here; the design is native to Core
Solidity (a **singleton** holding all events as ADT values in a map, rather than
the factory-deploys-one-contract-per-event shape Solidity would push you
toward). See [`core/README.md`](./core/README.md) for the design and the full
list of deviations, and [`core/COVERAGE.md`](./core/COVERAGE.md) for
how every mechanic in [`spec.md`](./spec.md) maps to a test.

## Layout

| Path | What |
|---|---|
| `core/Kodyl.sol` | the contract - the whole protocol, one singleton |
| `core/kodyl.sol` | shared module: the infrastructure the language doesn't provide yet (checked-math shims, revert/event builders, env wrappers) |
| `core/Probe.sol` | a toolchain canary that exercises the full compile pipeline |
| `core/README.md`, `core/COVERAGE.md` | design + deviations, and the spec-to-test map |
| `scripts/check-core.sh` | the compile pipeline: `sol-core` -> `yule` -> `solc` -> deployable hex |
| `scripts/deploy-anvil.sh`, `scripts/seed-anvil.sh` | deploy + seed a local node |
| `scripts/deploy-testnet.sh`, `scripts/seed-testnet.sh` | deploy + seed a public testnet (env-driven, chain-guarded); records land in `deployments/<chainid>.json` |
| `scripts/measure.sh` | reproduce the measured gas/size numbers on a scratch node |
| `deployments/` | committed per-network deployment records (see `deployments/README.md`, `VERIFICATION.md`) |
| `test/` | a **Foundry harness** (Solidity) that deploys the compiled Core bytecode and drives it - the tests are how the port is verified |
| `frontend/` | a React + viem demo dApp (see `frontend/README.md`) |
| `mailbox/` | a zero-dependency Node relay for proof-based check-in vouchers (see `mailbox/README.md`) |
| `spec.md` | the language-agnostic protocol specification |

## Toolchain

The contract is compiled by an external pipeline, not `forge`. Foundry is
present purely as a **test harness**: `forge test` compiles the `test/`
Solidity, which reads `core/build/*.hex` and deploys it. (That is why
`foundry.toml` sets `src = "test"` - there is no Solidity `src` tree.)

## Build & test

The deployable artifacts (`core/build/*.hex`, the generated `*.yul`, and the
`TOOLCHAIN` stamp) are committed, so a fresh clone tests with zero toolchain
setup:

```shell
forge test                   # deploys the committed bytecode in forge and verifies behaviour
```

Rebuilding the bytecode itself needs the pinned toolchain:

```shell
./scripts/pin-toolchain.sh <solcore-checkout>   # one-time; requires nix
./scripts/check-core.sh                         # .sol -> Yul -> deployable hex
```

`pin-toolchain.sh` nix-builds `sol-core`/`yule` from a solcore checkout into
`toolchain/` (GC-rooted links plus a `std` snapshot at the same rev, recorded
in `toolchain/SOLCORE_REV`); `check-core.sh` consumes them (every path is
env-overridable: `SOL_CORE`, `YULE`, `SOLC`, `STD`) and stamps each build
into `core/build/TOOLCHAIN`. CI re-proves on every core change that the
committed artifacts are byte-identical to a from-source rebuild at the pinned
rev - see [`VERIFICATION.md`](./VERIFICATION.md) for the third-party recipe.

## Demo (local anvil)

The full demo, including proof-based check-in, runs in three terminals:

```shell
# 1) a local node
anvil

# 2) deploy + seed, then serve the dApp
./scripts/deploy-anvil.sh && ./scripts/seed-anvil.sh
cd frontend && npm install && npm run dev

# 3) the voucher relay for proof-based check-in
node mailbox/server.mjs        # http://localhost:8787 (PORT to override)
```

The mailbox is optional: without it, the door's operator outbox and direct
on-chain submission still work; it only carries a signed `Presence` to a
stranded attendee for self-rescue. See [`mailbox/README.md`](./mailbox/README.md)
for the API and the trust model, and [`frontend/README.md`](./frontend/README.md)
for the dApp.

## Measured

From `scripts/measure.sh` (a full lifecycle on a scratch anvil node,
deterministic timestamps, solcore rev `1950e707` - byte-identical `Kodyl.hex`
to the previous `8a77bd3f` pin, so every number carried over unchanged on
rerun):

| Measurement | Value |
|---|---:|
| deployed runtime size | 10051 bytes |
| deploy gas | 2250651 |
| createEvent | 250306 |
| register (first attendee) | 141453 |
| checkIn (single) | 124994 |
| checkInBatch (10 attendees) | 575467 |
| claim | 121020 |
| claimDust | 63949 |

The runtime is 40.9% of the 24576-byte EIP-170 limit. `createEvent` is a state
write, not a contract deployment - creating an event costs ~250k gas, where
the factory shape classic Solidity pushes toward would pay deployment gas per
event. Rerun `scripts/measure.sh` to reproduce the table.

## Status

Core Solidity is a research language and nowhere near production. This repo
is a showcase of its current state with a testnet demo target (Sepolia, via
`scripts/deploy-testnet.sh` - env-driven signer, chain id asserted, mainnet
hard-refused); it is not, and should not become, a mainnet deployment. The
accounting is adversarially tested (reentrancy, indivisible-amount
conservation, full-lifecycle invariants), but the language, the compiler, and
this contract are all young. Live deployments are recorded in
`deployments/<chainid>.json` and verifiable per
[`VERIFICATION.md`](./VERIFICATION.md).

## License

MIT.
