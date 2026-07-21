# Kodyl - Core Solidity port

A port of `src/KodylEvent.sol` and `src/KodylFactory.sol` to Core Solidity
(`.solc`, the [solcore](https://github.com/argotorg/solcore) research
language), as a showcase of the current state of the language. The Foundry
suite under `test/unit` and `test/invariant` is the behavioral oracle;
`test/core` re-runs it against the bytecode compiled from these sources.

## Layout

| File | Purpose |
|---|---|
| `KodylEvent.solc` | The event contract - full behavioral parity with the Solidity original |
| `KodylFactory.solc` | The factory as a registry (see deviation 1) |
| `KodylFactoryV2.solc` | Research spike, SUCCESSFUL: restores the real `createEvent` via the stencil pattern (deviation 1) |
| `kodyl.solc` | Shared module (env wrappers, checked-math shims, revert/event builders, validation), imported as `lib.kodyl.{*}` |
| `Probe.solc` | Minimal worked example of the pipeline |
| `build/` | Pipeline output (gitignored) |

## Building and testing

```
./scripts/check-core.sh          # .solc -> .hull (sol-core) -> .yul (yule) -> hex (solc)
forge test --match-path 'test/core/*'
```

Toolchain is pinned in `scripts/check-core.sh` to the solcore checkout the
installed `sol-core` was built from (`~/temp_dev/solcore`, rev `1d490d8b`).
The forge tests deploy the produced initcode with ABI-appended constructor
args (`test/core/CoreDeploy.sol`) and drive it through the ordinary Solidity
interfaces - selectors, event topics, and revert payloads are all asserted
byte-for-byte by the inherited oracle tests.

## Numbered deviations from the Solidity original

1. **Factory deployment needs a stencil.** Core Solidity cannot reference a
   sibling contract's initcode (the compiler nests only its own runtime
   object), so `KodylFactory.solc` ships as a registry: `createEvent` is
   replaced by `validateEventParameters` (identical checks and revert
   payloads, in order) plus `registerEvent(evt)`, which re-reads the event's
   parameters through its getters, re-validates, tracks, and emits
   `EventCreated`. Duplicate registration reverts `EventAlreadyRegistered()`.
   **The research spike then restored the real `createEvent`**:
   `KodylFactoryV2.solc` takes the address of a STENCIL - a helper contract
   whose runtime code IS KodylEvent's initcode, deployed with a 13-byte
   returner prefix (`600d380380600d6000396000f3` ++ initcode) - and
   `createEvent` extcodecopies it, appends the in-language
   `abi_encode`-d 9-argument tuple (contiguity guaranteed because
   `allocate_memory` advances the free pointer abi_encode continues from),
   and CREATE2s a real KodylEvent, salted like the original
   (packed sender ++ eventStart ++ timestamp ++ eventCount). Verified by a
   full register/checkIn/claim lifecycle on a factory-deployed instance.
   V2's constructor takes (maintainer, stencil) - one extra arg vs the
   original.
2. **checkInBatch via manual fallback dispatch.** The std ABI decoder for
   dynamic arrays is a stub, so `checkInBatch(address[])` cannot be a typed
   public function. The fallback matches the canonical selector and decodes
   the calldata array by hand: same ordering, same skip semantics, same
   `BatchTooLarge` payload. Malformed calldata is treated more leniently
   than 0.8 strict decoding.
3. **receive() emulated in the fallback.** The language has no `receive`;
   empty calldata routes to the payable fallback, which reverts
   `TransferFailed()` exactly like the original's receive. Unknown selectors
   revert with empty data, as Solidity does for a contract without fallback.
4. **Non-payable functions called with value** revert with the dispatch
   layer's `Error(0xb5988ea3)` instead of Solidity's empty revert. Untested
   by the oracle; latent difference.
5. **Checked arithmetic is shimmed.** Core Solidity `+ - * / %` wrap (raw EVM
   ops). `addCk/subCk/mulCk` reproduce `Panic(0x11)` and `solAssert`
   reproduces `Panic(0x01)` exactly where the Solidity source was checked;
   spots inside `unchecked` blocks in the source stay raw. `&&`/`||` do not
   short-circuit in Core Solidity - every guard was audited to be
   side-effect-free and division-free.
6. **AttendeeStatus costs 4 storage slots per mapping entry** (right-nested
   sum representation: n-1 slots for n variants). Behaviorally identical,
   gas diverges.
7. **Cross-contract reads use CALL via std raw_call** (`maintainer()`,
   registerEvent's parameter reads) where solc emits STATICCALL for view
   calls, and a failed call reverts empty rather than bubbling returndata.
8. **Constants are functions.** No `constant` keyword and no time-unit sugar:
   `MAX_BATCH_SIZE()`, `DUST_CLAIM_TIMEOUT()`, `MIN_CANCELLATION_BUFFER()`
   return literals (`30 days` = 2592000).
9. **Events are hand-rolled** over `log1..log3`; topic0 is derived in-source
   with compile-time-folded `keccakLit("Sig(...)")`. `MetadataUpdated(string)`
   data uses `abi_encode` + the dispatch size idiom. All emissions are
   verified by the oracle's `expectEmit` assertions.
10. **Reason strings are precomputed packed words.** String literals exist
    only at compile time (`string`, not constructible as `memory(string)`),
    so `InvalidEventParameters(string)` payloads embed the utf8 words with
    the plain text in comments, and `VERSION()` builds "1.0.0" by hand.

## What the port exercises that no single solcore example does

ADT-valued mappings + derived state machines with `match`, a 9-argument
constructor with a trailing dynamic string, payable/non-payable dispatch,
hand-rolled indexed events, byte-exact custom errors with arguments,
cross-contract calls, storage arrays with DynArray returns, a shared user
module (`export`/`import lib.`), for-loops over calldata, and Panic-faithful
checked-arithmetic shims - all verified against a pre-existing Solidity test
suite through real deployed bytecode.
