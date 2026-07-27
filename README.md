# Kodyl

> Event deposits with skin in the game, implemented in **Core Solidity**.

Attendees stake a deposit to register for an event. Show up and reclaim it plus
a pro-rata share of the no-shows' forfeited deposits; don't show up and you lose
your stake. Leftover rounding dust goes to a protocol maintainer. The concept is
a tribute to [Kickback](https://kickback.events/).

## What this repo is

This is a from-scratch implementation of Kodyl in
[**Core Solidity**](https://github.com/argotorg/solcore) (`.solc`), the
research language compiled by `sol-core`. It is a deliberate exercise in
building a real, non-trivial contract on the language as it exists today -
leaning into what it does well (payload-carrying ADTs as first-class storage,
exhaustive `match`, typeclass-derived encoding) and documenting where it does
not yet reach (checked arithmetic, events, dynamic-array params - all shimmed).

There is no "classic Solidity" version here; the design is native to Core
Solidity (a **singleton** holding all events as ADT values in a map, rather than
the factory-deploys-one-contract-per-event shape Solidity would push you
toward). See [`core/README.md`](./core/README.md) for the design and the full
list of numbered deviations, and [`core/COVERAGE.md`](./core/COVERAGE.md) for
how every mechanic in [`spec.md`](./spec.md) maps to a test.

## Layout

| Path | What |
|---|---|
| `core/Kodyl.solc` | the contract - the whole protocol, one singleton |
| `core/kodyl.solc` | shared module: the infrastructure the language doesn't provide yet (checked-math shims, revert/event builders, env wrappers) |
| `core/Probe.solc` | a toolchain canary that exercises the full compile pipeline |
| `core/README.md`, `core/COVERAGE.md` | design + deviations, and the spec-to-test map |
| `scripts/check-core.sh` | the compile pipeline: `sol-core` -> `yule` -> `solc` -> deployable hex |
| `scripts/deploy-anvil.sh`, `scripts/seed-anvil.sh` | deploy + seed a local node |
| `test/` | a **Foundry harness** (Solidity) that deploys the compiled Core bytecode and drives it - the tests are how the port is verified |
| `frontend/` | a React + viem demo dApp (see `frontend/README.md`) |
| `spec.md` | the language-agnostic protocol specification |

## Toolchain

The contract is compiled by an external pipeline, not `forge`. `sol-core` and
`yule` are built from a pinned solcore checkout; `scripts/check-core.sh` records
the exact paths. Foundry is present purely as a **test harness**: `forge test`
compiles the `test/` Solidity, which reads `core/build/*.hex` and deploys it.
(That is why `foundry.toml` sets `src = "test"` - there is no Solidity `src`
tree.)

## Build & test

```shell
./scripts/check-core.sh      # compile the Core Solidity contract to bytecode
forge test                   # deploy that bytecode in forge and verify behaviour
```

For the demo dApp against a local anvil node, see [`frontend/README.md`](./frontend/README.md).

## Status

Core Solidity is a research language and nowhere near production. This repo is a
showcase of its current state, not a deployment target. The accounting is
adversarially tested (reentrancy, indivisible-amount conservation, full-lifecycle
invariants), but the language, the compiler, and this contract are all young.

## License

MIT (pending).
