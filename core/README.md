# Kodyl in Core Solidity

The Kodyl concept - stake a deposit to register for an event, checked-in
attendees reclaim it plus a pro-rata share of no-show forfeitures, dust goes
to a maintainer (see `spec.md`) - implemented natively in
[Core Solidity](https://github.com/argotorg/solcore), designed around what
the language does well today rather than mirroring the factory architecture
classic Solidity would push toward.

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
- Per-event tallies are the product-type dual of the same idea: one positional
  value, `data Counters = Counters(uint256, uint256, uint256, uint256)`
  (registered, checkedIn, claimed, held), behind the event id - a
  single-constructor product lays out with no tag word, so an unset id reads
  back as `Counters(0, 0, 0, 0)`, the zero-slot rule shared with
  `NoEvent`/`None`. The whole-record read-modify-write has a measured gas
  cost (+4-6k on single-mutation tests, e.g. +5036 on the register happy
  path; only +167 on the 100-attendee batch, whose counters write happens
  once per call) - a trade taken deliberately for one value per event.
- Lifecycle state is never stored; it is derived from timestamps by a pure
  function and matched on.
- Custody is shared (one contract balance), so accounting is explicit: a
  per-event pot (`held`) plus a global ledger (`totalHeld`), with
  `balance >= totalHeld` asserted after every ETH movement. The direction is
  `>=`, not `==`: forced ETH (selfdestruct / block-reward payments) can push
  the balance above the ledger and cannot be rejected (see the Security
  review section). A side benefit: per-event dust is exact - `claimDust`
  pays out the pot, not a balance reading.
- Proof-based check-in rides on the std's EIP-712 helpers (`std/eip712.solc`,
  the argotorg pin). Two hand-rolled struct hashes (`Ticket(uint256 eventId)`,
  `Presence(uint256 eventId,address attendee)`) built with
  `concat`/`keccak256_` - there is no `hashStruct` helper - feed the 0x1901
  digest, then split-form `ecrecover` recovers each signer. A proof carries
  no expiry of its own: the derived-state check-in gate (Active/Dispute) is
  the single time bound - one gate, not two. Both
  `checkInWithProof` and `checkInBatchWithProofs` share one internal
  `verifyProof`, and `ecrecover` goes through a `recoverStrict` shim that
  zeroes the scratch slot first (std's `ecrecover` reads its result from
  scratch without pre-zeroing, so an invalid recovery would otherwise return
  a stale word instead of reverting - see the Security review section).
  Door operators are a nested-mapping set, `mapping(uint256, mapping(address,
  bool))`, gated organizer-only, managed by `setOperator(eid, operator, bool)` -
  the public `bool` parameter decodes strictly (a word above 1 reverts
  `DirtyHigherBitsForBool`), courtesy of the std's `bool:ABIDecode` instance
  landed at the `1fb1f880` re-pin.

## Layout

| File | Role |
|---|---|
| `Kodyl.solc` | The whole protocol: one contract, 33 entry points (32 typed public functions plus `checkInBatch` through the payable fallback) |
| `kodyl.solc` | Shared module (`import lib.kodyl.{*}`): infrastructure the language does not provide yet - checked-math shims, revert/event builders, env wrappers, validation |
| `Probe.solc` | Toolchain canary: minimal contract proving the pipeline end to end |
| `build/` | Pipeline output; the deployable `.hex`, generated `.yul`, and `TOOLCHAIN` stamp are committed (so `forge test` works without the toolchain), `.hull`/`.abi` intermediates stay local |
| `COVERAGE.md` | spec.md mechanics and invariants mapped to tests |

Build and test:

```
./scripts/check-core.sh          # sol-core -> yule -> solc, pinned toolchain
forge test                       # forge is a harness only (see foundry.toml)
```

`test/Kodyl.t.sol` (83 scenarios) and `test/KodylInvariant.t.sol` (128k-call
ledger fuzz across three concurrent events), plus `test/KodylAccounting.t.sol`
and `test/KodylConservation.t.sol` (reentrancy + full-lifecycle conservation)
and `test/KodylEcon.t.sol` (the adversarial-economics payoff matrix behind
`ECONOMICS.md`: exact per-actor ETH deltas for each attack strategy),
drive the compiled bytecode through a typed Solidity interface inside forge -
selectors, event topics, and revert payloads are asserted byte-for-byte.
`test/CoreProbe.t.sol` adds 14 canary tests pinning the language behaviors the
design leans on (raw-bytes `require` reverts, `Str`-instance selector folding,
UFCS storage arrays, bare literals, std eip712 helpers plus the hand-rolled
hashStruct pattern, split-form `ecrecover` with its revert-not-zero failure
modes, and lazy calldata dynamic arrays: address, bytes, and uint256
elements).

## What the language provides vs what the module shims

Provided by the language and leaned on hard: ADT storage with derived
`CanStore` (including the 8-slot `EventRec` behind a mapping and the tagless
`Counters` product), exhaustive `match` with payload binding, nested mappings,
storage arrays of strings with UFCS methods (`uris.push(u)`, `uris.length()`,
indexing), user-defined `Str` instances (a string literal at a typed position
folds through `fromString` at compile time - the `ErrSel` selector mechanism),
bare integer literals at `uint256` sites, canonical Solidity selectors from
dispatch, `payable` dispatch, compile-time-folded `keccakLit`, for-loops, and
the module system.

Shimmed in `kodyl.solc` because the language does not have it yet (each maps
to a tracked upstream gap). The list is also a changelog of the language
closing gaps: it has shrunk twice - the `8a77bd3f` re-pin brought runtime
string literals, moving item 4 from fully-shimmed to wire-shape-only, and the
`1950e707` re-pin brought lazy calldata-array decoding, moving item 5 from
gap-workaround to deliberate retention - so each item carries its status at
the pinned rev.

1. **Checked arithmetic** (`addCk`/`subCk`/`mulCk`/`solAssert` reproducing
   `Panic(0x11)`/`0x01`) - operators wrap today (solcore #484, still open
   upstream at the pinned rev).
2. **Events** - no `emit`; hand-rolled `log1..log3` emitters, generic over
   topics.
3. **Errors** - no custom-error syntax. An `ErrSel` type with a `Str`
   instance folds error-signature literals to their 4-byte selectors at
   compile time, so zero-arg sites read `fail("X()")` /
   `requireK(cond, "X()")`; errors with arguments still get hand-built
   payloads matching `abi.encodeWithSelector` byte-for-byte (`revertWith2`,
   `revertStr`), fed the same signature literals.
4. **The `Error(string)` wire shape** (narrowed at the `8a77bd3f` re-pin) -
   string literals materialize at runtime, and every
   `InvalidEventParameters(string)` reason is now a source
   literal fed through `revertStr`. What stays shimmed is the wire format:
   native `require(cond, "message")` reverts the raw UTF-8 bytes, not
   Solidity `Error(string)` (pinned by
   `test_probe_requireMessage_revertsRawBytes`), so `revertStr` builds the
   ABI encoding by hand - and the constructor keeps one precomputed packed
   word ("Zero address"), because string literals do not materialize in
   deploy code.
5. **`receive`, and one historical array decoder** - the payable fallback
   rejects stray ETH (empty calldata reverts) and hand-decodes
   `checkInBatch(uint256,address[])` from raw calldata. The hand-decoding
   predates the `1950e707` re-pin, which brought lazy calldata dynamic-array
   decoding (`calldata(array(T))` params with `arr[i]`/`arr.length()`; the
   memory-array decoder is still a stub). `checkInBatch` stays hand-decoded
   deliberately - wire compat, the ETH rejection lives in the same fallback,
   and it is the exhibit of what pre-decoder Core Solidity required.
6. **Environment globals** - `msg.sender`/`block.timestamp` etc. are opcode
   wrappers typed in the module.

Zero `assembly` blocks anywhere: every opcode used is an imported typed
function.

## Storage layout

How Core Solidity lays out this contract's storage, derived from the
committed `build/Kodyl.yul`. Contract fields take consecutive slots in
declaration order:

| Slot | Field | Type |
|---:|---|---|
| 0 | `maintainer` | `address` |
| 1 | `eventCount` | `uint256` |
| 2 | `totalHeld` | `uint256` |
| 3 | `eventsRec` | `mapping(uint256, EventRec)` |
| 4 | `metadataUris` | `array(string)` (length word) |
| 5 | `cancelledM` | `mapping(uint256, bool)` |
| 6 | `statusM` | `mapping(uint256, mapping(address, AttendeeStatus))` |
| 7 | `countersM` | `mapping(uint256, Counters)` |
| 8 | `operatorsM` | `mapping(uint256, mapping(address, bool))` |

A mapping value lives at `keccak256(slot ++ key)` - note the argument order,
which is **reversed** from classic Solidity's `keccak256(key ++ slot)`.
Nested mappings iterate the rule: a `statusM` entry sits at
`keccak256(keccak256(6 ++ eid) ++ attendee)`, and an `operatorsM` entry at
`keccak256(keccak256(8 ++ eid) ++ operator)`. Dynamic arrays and strings
match classic Solidity exactly: array length at slot `p`, element `i` at
`keccak256(p) + i`, strings in the usual short/long form.

At its hashed base slot, an ADT value lays out per its derived `Generic`
representation:

- `EventRec` is a two-constructor sum: one tag word (0 = `NoEvent`,
  1 = `Ev`), then seven payload slots - organizer, depositAmount,
  cancellationDeadline, eventStart, eventEnd, disputePeriod, maxAttendees -
  eight slots per event.
- `Counters` is a single-constructor product: no tag word, four consecutive
  slots - registered, checkedIn, claimed, held.
- `AttendeeStatus` has five nullary constructors and its derived
  representation is a nested binary sum, so the tag is unary across
  consecutive slots: a read walks 0/1 words and stops at the first 0.
  `None` = `[0]` (the zero-slot rule), `Registered` = `[1,0]`,
  `Cancelled` = `[1,1,0]`, `CheckedIn` = `[1,1,1,0]`,
  `Claimed` = `[1,1,1,1]`. (A rewrite to a shorter constructor can leave
  stale deeper words; they are unreachable - the walk stops first.)

Only the ABI and the events are stable interfaces for indexers. The slots
above are an implementation detail of the std's derived `CanStore` instances
and can renumber under refactors - the `Counters` refactor did exactly that.

## Design deviations from spec.md

- **Shared custody.** The factory shape the concept started from implies
  per-event fund isolation; the singleton pools custody and compensates with
  the ledger invariants above. spec.md now names this the central trade; it
  remains the one real security-posture trade of the design.
- `EventAlreadyStarted` covers every non-Registration state for
  `cancelEvent` (including already-cancelled), instead of a dedicated error.
- After `DUST_CLAIM_TIMEOUT`, unclaimed payouts sweep to the maintainer with
  the dust. A checked-in attendee who claims after that sweep is told
  plainly: `claim` reverts `PayoutSwept()` rather than underflowing into an
  opaque panic. (Once implementation-defined, now specified in spec.md.)
- `disputePeriod` is validated to `[1 hour, 30 days]` - deliberate defensive
  validation (a zero window would strand late-but-present attendees, an
  unbounded one would lock funds for years). Originally a review finding
  against a spec that gave only a 24h default; the bounds and rationale are
  now specified in spec.md, so this is history rather than a live deviation.
- **Cancelled events have no sweep path.** `claimRefund` works forever; there
  is deliberately no timeout after which the maintainer can take a cancelled
  event's pot. A cancelled pot is exactly the attributed deposits - no dust,
  no forfeitures - so a sweep would convert fail-safe funds (locked if never
  claimed, but unstealable) into a maintainer seizure surface. Refunds never
  expire.
- **`cancel` still works on a cancelled event until the deadline.** Attendee
  `cancel` does not check `cancelledM`: before the cancellation deadline both
  paths pay the same refund, so the overlap is funds-safe - but it emits
  `RegistrationCancelled` where `claimRefund` emits `RefundClaimed`.
  Indexers should treat the two as one deposit-returned family. Deliberate;
  the demo UI never routes there.
- **One string-carrying error selector.** Constructor and `setMaintainer`
  failures reuse the `InvalidEventParameters(string)` selector even though no
  event parameters are involved - a deliberate wire-compat choice: the ABI
  carries a single reason-string error shape and every misuse revert decodes
  through it.
- **Two-tier read surface.** The ADT-backed getters (`getEvent`, `organizer`,
  `getState`, `metadataURI`, `rewardPerAttendee`) revert `EventNotFound` for
  an unknown id; the raw-mapping getters (`attendees`, `cancelled`,
  `registeredCount`, `checkedInCount`, `claimedCount`, `held`) return zero,
  mirroring what a Solidity public mapping would do. The split is deliberate
  and pinned by tests.
- **The maintainer is assumed to accept ETH.** A maintainer contract that
  reverts on receipt blocks only dust egress - `claim`, `cancel`, and
  `claimRefund` pay the caller and never touch the maintainer - and the
  block self-heals: the maintainer role rotates itself to a working address
  via `setMaintainer`.

## Trust surface

Check-in authority is custody. The organizer alone can capture every honest
deposit by registering a sybil and checking in only the sybil: with ten
honest attendees at 1 ETH each, the sybil claims 11 ETH at Settled - its own
deposit plus all ten forfeitures. The inverse abuse routes value to the
maintainer instead: an organizer who checks nobody in turns all deposits
into dust, claimable immediately at Settled when there are zero check-ins
and after the 30-day timeout otherwise. Attendees therefore trust the
organizer with their stake; the mitigations are economic and reputational
(an organizer who seizes deposits kills their next event), not
cryptographic. The maintainer is the second trusted role: it receives dust,
rotates itself via `setMaintainer`, and is assumed to accept ETH (the
liveness deviation above). Nothing lets the maintainer touch attendee funds
before the dust gates open.

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

A second, full fresh-eyes round ran before the testnet push: a multi-agent
review across funds safety, spec conformance, language traps, the test
suite, and the docs, with every finding adversarially verified before it
counted. It found no funds-loss bugs. The one contract change it produced:
`checkInBatch` now rejects address words with dirty upper bits with
`DirtyHigherBitsForAddress()`, matching the std decoder on the typed
`checkIn` path (previously a dirty word silently no-oped into an unset
mapping key). The rest of the round hardened the tests: the lifecycle
invariant handler became phase-aware (claim/check-in/dust paths now succeed
hundreds of times per 128k-call campaign instead of single digits), and the
fuzz runs under a forced-ETH regime asserting the tight ledger form
`balance == totalHeld + forced ETH`.

A third round covered the proof-based check-in (v2), again multi-agent with
adversarial verification. The one finding worth recording here is a **latent
std defect**: `std/eip712.solc`'s neighbour `ecrecover` (in `std/std.solc`)
reads its result from scratch memory `[0, 32)` but never pre-zeroes it, and
the precompile writes nothing on an invalid recovery (a `v` outside `{27, 28}`
or an unrecoverable `r`/`s`, past the s-only malleability guard). The EVM
leaves the return region untouched, so a stale scratch word would be returned
as a bogus signer instead of reverting `ECRecoverFailed`. It was **not
exploitable in Kodyl** (the stale value can never equal a registered attendee
on the ticket check, and on the presence check it can only equal the attendee,
who would have to be the organizer/operator anyway), but the guarantee was
one refactor away from breaking, so `verifyProof` routes every recovery
through `recoverStrict` (`mstore(0, 0)` then `ecrecover`), which forces the
intended revert. Regression-pinned by `test_proofCheckIn_invalidRecoveryDoesNotReturnStaleSigner`
(mutation-verified: raw `ecrecover` fails it) and reported upstream.
