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
  `enum EventRec { NoEvent, Ev(EventRecord) }` - the payload a named
  `struct EventRecord` - stored in `mapping(uint256 => EventRec)`.
  "Deployment" is a state write; createEvent returns a sequential id.
  The design rule throughout: **sums stay pattern-matched** (exhaustiveness
  is what the type system buys), **wide products carry field names**
  (`rec.eventStart`, not position four of a seven-slot positional
  destructure where five fields share a type and a silent swap typechecks).
- `NoEvent` is declared first, so an unset id reads back as `NoEvent` from
  the zero slot pattern, and **exhaustive matching forces every function to
  handle the missing-event case** - the type system does what address
  checks do in Solidity.
- Attendee status is the same idea one level down:
  `mapping(uint256 => mapping(address => AttendeeStatus))` with `None` first.
- Per-event tallies are the product-type dual of the same idea: one named
  record, `struct Counters { registered; checkedIn; claimed }`, behind the
  event id - a plain product lays out with no tag word, so an unset id reads
  back as `Counters(0, 0, 0)`, the zero-slot rule shared with
  `NoEvent`/`None`. Updates read the record and write a whole reconstructed
  value: partly the deliberate one-value-per-event trade, partly forced -
  struct member assignment through a mapping value is unimplemented at this
  pin (SC0231).
- Lifecycle state is never stored; it is derived from timestamps by a pure
  function and matched on.
- Custody is shared (one contract balance), and the accounting is an opaque
  module, `lib.ledger`: the per-event pot and the global total live at
  ERC-7201-namespaced slots owned by the module, whose only exports are
  `potOf` / `ledgerTotal` / `credit` / `payOut`. The raw slot accessors and
  the ETH transfer are module-private, so "debit both ledgers, then send,
  then assert `balance >= total`" is not a convention reviewers check at
  five call sites - it is the only reachable order, and the invariant is
  asserted inside the module. The direction is `>=`, not `==`: forced ETH
  (selfdestruct / block-reward payments) can push the balance above the
  ledger and cannot be rejected (see the Security review section). A side
  benefit: per-event dust is exact - `claimDust` pays out the pot, not a
  balance reading.
- Proof-based check-in rides on the std's EIP-712 helpers (`std/eip712.sol`,
  the argotorg pin). Two hand-rolled struct hashes (`Ticket(uint256 eventId)`,
  `Presence(uint256 eventId,address attendee)`) built with
  `concat`/`keccak256_` - there is no `hashStruct` helper - feed the 0x1901
  digest, then split-form `ecrecover` recovers each signer. A proof carries
  no expiry of its own: the derived-state check-in gate (Active/Dispute) is
  the single time bound - one gate, not two. Both
  `checkInWithProof` and `checkInBatchWithProofs` share one internal
  `verifyProof`, calling std `ecrecover` directly: at this pin it pre-zeroes
  its return scratch (the defect we filed upstream was fixed - see the
  Security review section) and rejects malleable and failed recoveries.
  Door operators are a nested-mapping set, `mapping(uint256 =>
  mapping(address => bool))`, gated organizer-only, managed by
  `setOperator(eid, operator, bool)` - the public `bool` parameter decodes
  strictly (a word above 1 reverts `DirtyHigherBitsForBool`), courtesy of
  the std's bool `ABIDecode` impl landed at the `1fb1f880` re-pin.

## Layout

| File | Role |
|---|---|
| `Kodyl.sol` | The whole protocol: one contract, 33 entry points (32 typed public functions plus `checkInBatch` through the payable fallback) |
| `kodyl.sol` | Shared module (`import * from lib.kodyl`): infrastructure the language does not provide yet - checked-math shims, revert/event builders, env wrappers, validation, signature splitting |
| `ledger.sol` | Custody module (`import * from lib.ledger`): pot + total at namespaced slots, `credit`/`payOut` the only mutations, the raw transfer unexported |
| `Probe.sol` | Toolchain canary: minimal contract proving the pipeline end to end |
| `build/` | Pipeline output; the deployable `.hex`, generated `.yul`, and `TOOLCHAIN` stamp are committed (so `forge test` works without the toolchain), `.hull`/`.abi` intermediates stay local |
| `COVERAGE.md` | spec.md mechanics and invariants mapped to tests |

Build and test:

```
./scripts/check-core.sh          # sol-core -> yule -> solc, pinned toolchain
forge test                       # forge is a harness only (see foundry.toml)
```

`test/Kodyl.t.sol` (88 scenarios) and `test/KodylInvariant.t.sol` (128k-call
ledger fuzz across three concurrent events), plus `test/KodylAccounting.t.sol`
and `test/KodylConservation.t.sol` (reentrancy + full-lifecycle conservation)
and `test/KodylEcon.t.sol` (the adversarial-economics payoff matrix behind
`ECONOMICS.md`: exact per-actor ETH deltas for each attack strategy),
drive the compiled bytecode through a typed Solidity interface inside forge -
selectors, event topics, and revert payloads are asserted byte-for-byte.
`test/CoreProbe.t.sol` adds 17 canary tests pinning the language behaviors the
design leans on (raw-bytes `require` reverts, `Str`-impl selector folding,
UFCS storage arrays, bare literals, std eip712 helpers plus the hand-rolled
hashStruct pattern, split-form `ecrecover` with its revert-not-zero failure
modes, lazy calldata dynamic arrays: address, bytes, and uint256 elements,
enum-with-struct-payload mapping values, the struct read-reconstruct-write
mapping update, and ERC-7201-namespaced slots).

## What the language provides vs what the module shims

Provided by the language and leaned on hard: ADT storage with derived
`CanStore` (including the 8-slot `EventRec` behind a mapping and the tagless
`Counters` record), named `struct` fields with member access on match-bound
payloads, exhaustive `match` with payload binding, nested mappings, storage
arrays of strings with UFCS methods (`uris.push(u)`, `uris.length()`,
indexing), user-defined `Str` impls (a string literal at a typed position
folds through `fromString` at compile time - the `ErrSel` selector mechanism),
comptime `erc7201` namespacing, bare integer literals at `uint256` sites,
canonical Solidity selectors from dispatch, `payable` dispatch,
compile-time-folded `keccakLit`, for-loops, and the module system - including
export lists as visibility boundaries, which is what makes `lib.ledger`'s
opacity real rather than advisory.

Shimmed in `kodyl.sol` / `ledger.sol` because the language does not have it yet (each maps
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
   decoding (`calldata<array<T>>` params with `arr[i]`/`arr.length()`; the
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
| 2 | `eventsRec` | `mapping(uint256 => EventRec)` |
| 3 | `metadataUris` | `array<string>` (length word) |
| 4 | `cancelledM` | `mapping(uint256 => bool)` |
| 5 | `statusM` | `mapping(uint256 => mapping(address => AttendeeStatus))` |
| 6 | `countersM` | `mapping(uint256 => Counters)` |
| 7 | `operatorsM` | `mapping(uint256 => mapping(address => bool))` |

The money is not in the contract's declared fields at all: `lib.ledger` owns
the global total at the `erc7201("kodyl.ledger.total")` slot and each
event's pot at `hash2(erc7201("kodyl.ledger.pot"), eid)` - module-owned
namespaced storage, unreachable by slot number.

A mapping value lives at `keccak256(slot ++ key)` - note the argument order,
which is **reversed** from classic Solidity's `keccak256(key ++ slot)`.
Nested mappings iterate the rule: a `statusM` entry sits at
`keccak256(keccak256(5 ++ eid) ++ attendee)`, and an `operatorsM` entry at
`keccak256(keccak256(7 ++ eid) ++ operator)`. Dynamic arrays and strings
match classic Solidity exactly: array length at slot `p`, element `i` at
`keccak256(p) + i`, strings in the usual short/long form.

At its hashed base slot, an ADT value lays out per its derived `Generic`
representation:

- `EventRec` is a two-constructor sum: one tag word (0 = `NoEvent`,
  1 = `Ev`), then the `EventRecord` struct's seven field slots - organizer,
  deposit, cancellationDeadline, eventStart, eventEnd, disputePeriod,
  maxAttendees - eight slots per event, identical to the old positional
  payload.
- `Counters` is a plain named product: no tag word, three consecutive
  slots - registered, checkedIn, claimed. (The pot left for `lib.ledger`.)
- `AttendeeStatus` has six nullary constructors and its derived
  representation is a nested binary sum, so the tag is unary across
  consecutive slots: a read walks 0/1 words and stops at the first 0.
  Measured with raw slot reads at this pin: `None` = `[0]` (the zero-slot
  rule), `Registered` = `[1,0]`, `Cancelled` = `[1,1,0]`,
  `CheckedIn` = `[1,1,1,0]`, `Claimed` = `[1,1,1,1,0]`,
  `Rebated` = `[1,1,1,1,1]`. (A rewrite to a shorter constructor can leave
  stale deeper words; they are unreachable - the walk stops first.)

Only the ABI and the events are stable interfaces for indexers. The slots
above are an implementation detail of the std's derived `CanStore` impls
and can renumber under refactors - the ledger extraction did exactly that,
removing the old `totalHeld` field and shifting every mapping down a slot.

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

Check-in authority is custody, but its prize is bounded. An organizer who
registers a sybil and checks in only the sybil captures at most one deposit
of profit however many honest attendees registered: the attendance reward is
capped at REWARD_CAP_MULTIPLE (1) deposit, and the capped-off excess rebates
pro-rata to the no-shows (claimNoShowRebate) - with ten honest attendees at
1 ETH each, the sybil claims 2 ETH and each victim recovers 0.9.
The inverse abuse - checking nobody in - is
defused: a zero-check-in settlement is abandonment, every attendee reclaims
their deposit in full forever, and no sweep exists (the 30-day timeout sweep
applies only to checked-in-but-unclaimed payouts). Attendees therefore trust
the organizer with their stake; the mitigations are economic and reputational
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
adversarial verification. The one finding worth recording here was a **latent
std defect**: std `ecrecover` read its result from scratch memory `[0, 32)`
without pre-zeroing it, and the precompile writes nothing on an invalid
recovery (a `v` outside `{27, 28}` or an unrecoverable `r`/`s`, past the
s-only malleability guard) - so a stale scratch word would be returned as a
bogus signer instead of reverting `ECRecoverFailed`. It was **not exploitable
in Kodyl** (the stale value can never equal a registered attendee on the
ticket check, and on the presence check it can only equal the attendee, who
would have to be the organizer/operator anyway), but the guarantee was one
refactor away from breaking, so `verifyProof` routed every recovery through a
local `recoverStrict` shim (`mstore(0, 0)` then `ecrecover`) while the defect
was reported upstream. Upstream fixed it (solcore PR 553: std now clears the
scratch itself), the fix is in the pinned rev, and the shim is retired -
`verifyProof` calls std `ecrecover` directly. The regression test
`test_proofCheckIn_invalidRecoveryDoesNotReturnStaleSigner` stays, now
pinning the upstream guarantee instead of the shim.
