# Kodyl in Core Solidity

The Kodyl concept - stake a deposit to register for an event, checked-in
attendees reclaim it plus a pro-rata share of no-show forfeitures, dust goes
to a maintainer (see `spec.md`) - implemented natively in
[Core Solidity](https://github.com/argotorg/solcore), designed around what
the language does well today rather than mirroring the classic Solidity
architecture in `src/`.

## The design

Classic Kodyl is a factory that deploys one contract per event, because a
contract instance is Solidity's natural unit of state isolation. Core
Solidity's natural unit is **a value in a typed map**, so this is a
singleton:

- An event is a payload-carrying ADT:
  `data EventRec = NoEvent | Ev(organizer, deposit, deadline, start, end, dispute, cap)`
  stored in `mapping(uint256, EventRec)`. "Deployment" is a state write;
  createEvent returns a sequential id.
- `NoEvent` is declared first, so an unset id reads back as `NoEvent` from
  the zero slot pattern, and **exhaustive matching forces every function to
  handle the missing-event case** - the type system does what address
  checks do in Solidity.
- Attendee status is the same idea one level down:
  `mapping(uint256, mapping(address, AttendeeStatus))` with `None` first.
- Lifecycle state is never stored; it is derived from timestamps by a pure
  function and matched on.
- Custody is shared (one contract balance), so accounting is explicit: a
  per-event pot (`held`) plus a global ledger (`totalHeld`), with
  `balance == totalHeld` asserted after every ETH movement. A side benefit:
  per-event dust is exact - `claimDust` pays out the pot, not a balance
  reading.

## Layout

| File | Role |
|---|---|
| `Kodyl.solc` | The whole protocol: one contract, ~29 entry points |
| `kodyl.solc` | Shared module (`import lib.kodyl.{*}`): infrastructure the language does not provide yet - checked-math shims, revert/event builders, env wrappers, validation |
| `Probe.solc` | Toolchain canary: minimal contract proving the pipeline end to end |
| `build/` | Pipeline output (gitignored) |
| `COVERAGE.md` | spec.md mechanics and invariants mapped to tests |

Build and test:

```
./scripts/check-core.sh          # sol-core -> yule -> solc, pinned toolchain
forge test                       # forge is a harness only (see foundry.toml)
```

`test/Kodyl.t.sol` (41 scenarios) and `test/KodylInvariant.t.sol` (128k-call
ledger fuzz across three concurrent events), plus `test/KodylAccounting.t.sol`
and `test/KodylConservation.t.sol` (reentrancy + full-lifecycle conservation),
drive the compiled bytecode through a typed Solidity interface inside forge -
selectors, event topics, and revert payloads are asserted byte-for-byte.

## What the language provides vs what the module shims

Provided by the language and leaned on hard: ADT storage with derived
`CanStore` (including the 8-slot `EventRec` behind a mapping), exhaustive
`match` with payload binding, nested mappings, storage arrays of strings,
canonical Solidity selectors from dispatch, `payable` dispatch,
compile-time-folded `keccakLit`, for-loops, and the module system.

Shimmed in `kodyl.solc` because the language does not have it yet (each maps
to a tracked upstream gap):

1. **Checked arithmetic** (`addCk`/`subCk`/`mulCk`/`solAssert` reproducing
   `Panic(0x11)`/`0x01`) - operators wrap today (solcore #484).
2. **Events** - no `emit`; hand-rolled `log1..log3` emitters, generic over
   topics.
3. **Errors with arguments** - payloads built to match
   `abi.encodeWithSelector` byte-for-byte.
4. **Runtime strings** - largely closed by the language: as of the current
   pin, string literals materialize at runtime (`require(cond, "message")`
   works). What the module still shims is the wire format - the native revert
   is raw string bytes, not Solidity `Error(string)`, and constructor code
   cannot materialize literals - so `InvalidEventParameters(string)` reasons
   stay precomputed packed words (plaintext in comments) pending a builder
   migration that moves the strings into source.
5. **`receive` and dynamic-array parameters** - both live in the payable
   fallback: empty calldata reverts (stray-ETH rejection), and
   `checkInBatch(uint256,address[])` is decoded from calldata by hand (the
   std array decoder is a stub).
6. **Environment globals** - `msg.sender`/`block.timestamp` etc. are opcode
   wrappers typed in the module.

Zero `assembly` blocks anywhere: every opcode used is an imported typed
function.

## Design deviations from spec.md

- **Shared custody.** spec.md's factory rationale includes per-event fund
  isolation; the singleton pools custody and compensates with the
  ledger invariants above. This is the one real security-posture trade of
  the design.
- `EventAlreadyStarted` covers every non-Registration state for
  `cancelEvent` (including already-cancelled), instead of a dedicated error.
- After `DUST_CLAIM_TIMEOUT`, unclaimed payouts sweep to the maintainer with
  the dust (spec.md leaves late-claimer behavior after timeout implicit). A
  checked-in attendee who claims after that sweep is told plainly: `claim`
  reverts `PayoutSwept()` rather than underflowing into an opaque panic.
- `disputePeriod` is validated to `[1 hour, 30 days]`. spec.md gives only a
  default (24h) and no bounds; the range is deliberate defensive validation
  (a zero window would strand late-but-present attendees, an unbounded one
  would lock funds for years). Documented rather than removed.

## Security review

An adversarial review (three finder lenses - spec conformance, funds safety,
language traps - each finding then attacked by a skeptic) surfaced three real
issues, all fixed and regression-tested:

- **Forced-ETH brick (critical).** The `balance == totalHeld` invariant used
  strict equality; `selfdestruct` / block-reward payments can raise the
  balance without executing code, so 1 wei would have made the assert fail
  permanently and freeze every flow for every event. Fixed to `>=`
  (`test_forcedETH_doesNotBrickFlows`).
- **Check-in on a cancelled event (high).** `checkInInner` gated only on the
  time window, so the organizer could flip a registered attendee to
  CheckedIn after cancelling, stranding the deposit (no path back to a
  refund). Check-in is now gated on the derived state (Active/Dispute), which
  a cancelled event never has (`test_checkIn_rejectedAfterCancelSoRefundStaysOpen`).
- **disputePeriod bounds (low).** Documented above.
