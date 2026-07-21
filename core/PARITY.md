# Oracle parity map

Every test in the Foundry oracle (49 tests, all green against the Solidity
original) mapped to its verification against the Core Solidity port.
"Inherited" = the identical test re-runs against ported bytecode via
`test/core/CoreKodylEvent.t.sol` (only the deploy helper is overridden).

With the stencil spike landing (KodylFactoryV2), every oracle behavior has a
verified counterpart: nothing is N/A.

## test/unit/KodylEvent.t.sol - 33/33 inherited, all PASS

All 33 tests run unchanged against `core/build/KodylEvent.hex`:
constructor/getters (2), getState transitions (2), register (6), cancel (3),
claimRefund (4), checkIn + batch (6), claim (3), claimDust (3), cancelEvent
(3), setMetadataURI (1), receive rejection (1). Every `expectRevert` payload
and `expectEmit` topic asserted byte-for-byte.

## test/unit/KodylFactory.t.sol - 13 mirrored + 2 restored by the V2 spike

| Oracle test | Port verification | Status |
|---|---|---|
| test_constructor_setsMaintainer | CoreKodylFactory: same name | PASS |
| test_constructor_revertsOnZeroMaintainer | same name (failure via CREATE; exact payload pinned by setMaintainer zero-address test) | PASS |
| test_setMaintainer_onlyMaintainer | same name + MaintainerUpdated topics | PASS |
| test_setMaintainer_revertsForNonMaintainer | same name | PASS |
| test_createEvent_deploysAndTracks | CoreKodylFactoryV2: test_createEvent_deploysAndTracks (real on-chain deploy via stencil + CREATE2) | PASS |
| test_createEvent_multipleGetUniqueAddresses | CoreKodylFactoryV2: test_createEvent_uniqueAddresses | PASS |
| test_createEvent_revertsOnZeroDeposit | test_validate_revertsOnZeroDeposit | PASS |
| test_createEvent_revertsWhenStartNotFuture | test_validate_revertsWhenStartNotFuture | PASS |
| test_createEvent_revertsWhenEndBeforeStart | test_validate_revertsWhenEndBeforeStart | PASS |
| test_createEvent_revertsWhenDisputeTooShort | test_validate_revertsWhenDisputeTooShort | PASS |
| test_createEvent_revertsWhenDisputeTooLong | test_validate_revertsWhenDisputeTooLong | PASS |
| test_specCompliantDeadlineAccepted | same name | PASS |
| test_deadlineExactly2hBeforeAccepted | same name | PASS |
| test_deadlineTooCloseRejected | same name | PASS |
| test_deadlineAfterStartRejected | same name | PASS |

Port-only additions: setMaintainer zero/same reverts (pin revertStr1 bytes),
two-word reason revert (pins revertStr2 bytes), constants + VERSION,
registerEvent tracking/double-registration/multi-event.

## test/invariant/DepositAccounting.t.sol - inherited, PASS

`CoreDepositAccountingInvariant` re-runs the deposit-accounting invariant
(256 runs, 128,000 calls, zero reverts) against ported bytecode.

## Totals

| Suite | Tests | Result |
|---|---|---|
| Solidity oracle (unit + factory + invariant) | 49 | PASS |
| Port: inherited KodylEvent oracle | 33 | PASS |
| Port: factory mirror + additions | 20 | PASS |
| Port: V2 stencil createEvent spike | 4 | PASS |
| Port: stencil equivalence gate | 1 | PASS |
| Port: invariant re-run | 1 | PASS |
| Pipeline gates (probe, skeleton, state) | 4 | PASS |
| **Total** | **112** | **PASS** |
