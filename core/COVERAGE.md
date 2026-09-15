# spec.md coverage map

Every mechanic and invariant in `spec.md` mapped to the tests that verify it
against the compiled Core Solidity bytecode (`test/Kodyl.t.sol` unless noted).

## Core mechanics

| spec.md mechanic | Verified by |
|---|---|
| Organizer creates event with params | test_createEvent_sequentialIdsAndStorage, test_createEvent_emits |
| Parameter validation (deposit > 0, future start, end after start, deadline min 2h before event and in future, dispute period 1h..30d) | test_validation_reverts, test_validation_deadlineBoundary |
| Attendees register with exact deposit | test_register_happyPath, test_register_revertsOnWrongDeposit |
| Capacity cap (0 = unlimited) | test_register_revertsWhenFull (also: a cancellation frees the slot, then full again) |
| Registration closes at event start | test_register_revertsAfterStart |
| Cancel before deadline: immediate refund | test_cancel_refundsAndUpdatesLedger, test_cancel_atExactDeadline (deadline itself inclusive) |
| No refund after deadline | test_cancel_revertsAfterDeadline |
| Re-registration after cancellation | test_register_reRegisterAfterCancel |
| Organizer cancels event before start: full refunds | test_cancelEvent_lifecycle, test_claimRefund_afterCancelEvenPastDeadline |
| No event cancellation after start | test_cancelEvent_revertsAfterStart |
| Check-in by organizer, single + batch (max 100), invalid entries skipped | test_checkIn_happyAndSkip, test_checkInBatch_throughTypedInterface, test_checkInBatch_revertsWhenTooLarge, test_checkInBatch_maxSizeBoundary (exactly 100), test_checkInBatch_emptyArrayIsNoOp, test_checkInBatch_duplicatesCountOnce |
| Check-in window: eventStart through eventEnd + disputePeriod | test_checkIn_revertsOutsideWindow, test_checkIn_windowBackEdge (inclusive at exactly end + dispute, closed at +1 for both checkIn and checkInBatch), test_getState_transitionsOverTime |
| Pull-only claims after dispute period | test_claim_paysDepositPlusReward, test_claim_revertsBeforeSettledAndWhenNotCheckedIn, test_claim_andDustRevertDuringDispute (still NotSettled at the inclusive Dispute back edge) |
| Pro-rata no-show distribution + reward math | test_claim_paysDepositPlusReward (3 reg / 2 checked / 0.5 ETH each) |
| Reward capped at REWARD_CAP_MULTIPLE (1) deposit; boundary at noShows == checkedIn has no rebate | test_rewardCap_boundaryAtEqualCounts |
| No-show rebate: gates (NotSettled, wrong status, NothingToRebate), RebateClaimed event, terminal Rebated status, frozen counter math | test_claimNoShowRebate_gatesAndFrozenMath, test_rewardCap_boundaryAtEqualCounts |
| Late rebate after the timeout sweep reverts PayoutSwept | test_claimNoShowRebate_afterSweepRevertsPayoutSwept |
| Early all-claimed dust stays shut while a rebate pool exists | test_claimDust_waitsForTimeoutWhileRebatePoolExists |
| Dust to maintainer after all claims or timeout | test_claimDust_remainderAfterAllClaims, test_claimDust_gatesAndTimeout, test_claimDust_revertsWhenPotEmpty (exact division leaves a zero pot: DustNotClaimable) |
| Zero check-ins: abandonment - refunds forever, no dust path even past the sweep timeout, refund gate opens only at Settled | test_claimRefund_zeroCheckInAbandonment |
| A late check-in during Dispute flips an abandoning event into normal settlement (refunds never open) | test_claimRefund_abandonmentClosedByLateCheckIn |
| Reject unexpected ETH | test_fallback_rejectsPlainTransferAndUnknownSelector, test_fallback_shortCalldataRevertsEmpty, test_nonPayable_rejectsValueWithStdError (value to a non-payable function: exactly the std dispatcher's NonPayableReceivedValue selector, raw bytes pinned) |
| Mutable metadata URI with event | test_setMetadataURI, test_setMetadataURI_anyState (deliberately state-independent: works in Active, Settled, and on a cancelled event) |
| Maintainer management | test_setMaintainer, test_claimDust_paysRotatedMaintainer (after rotation, dust and DustClaimed go to the new maintainer only) |

## Attendee status transitions (spec.md "Valid transitions")

| Transition | Verified by |
|---|---|
| None -> Registered | test_register_happyPath |
| Registered -> Cancelled (cancel) | test_cancel_refundsAndUpdatesLedger |
| Registered -> Cancelled (claimRefund) | test_claimRefund_afterCancelEvenPastDeadline |
| Registered -> CheckedIn | test_checkIn_happyAndSkip |
| Cancelled -> Registered | test_register_reRegisterAfterCancel |
| CheckedIn -> Claimed | test_claim_paysDepositPlusReward |
| Claimed terminal / invalid transitions revert | test_register_revertsWhenAlreadyRegistered, test_cancel_revertsWhenNotRegistered, test_claim_paysDepositPlusReward (second claim), test_claimRefund_afterCancelEvenPastDeadline (double refund) |

## spec.md invariants

| # | Invariant | Verified by |
|---|---|---|
| 1 | Deposit accounting: balance always covers the deposit ledger | In-contract solAssert of balance >= totalHeld after every ETH movement (>= absorbs forced ETH); the harness invariants prove the tight form balance == totalHeld + forcedETH under a fuzzed forced-ETH regime: KodylInvariant.t.sol invariant_ledgersConsistent and KodylConservation.t.sol invariant_ledgerThreeWayEquality (128k calls each, 3 events, per-event and global ledgers) |
| 2 | No double claims (Claimed terminal) | test_claim_paysDepositPlusReward (second claim reverts InvalidAttendeeStatus(4, 3)), test_claimRefund_afterCancelEvenPastDeadline (double refund reverts InvalidAttendeeStatus(2, 1)) |
| 3 | No post-deadline cancellation | test_cancel_revertsAfterDeadline |
| 4 | Claims only after dispute period | test_claim_revertsBeforeSettledAndWhenNotCheckedIn, test_claim_andDustRevertDuringDispute |
| 5 | Check-in window enforced | test_checkIn_revertsOutsideWindow, test_checkIn_windowBackEdge |
| 6 | Event cancellation only before start | test_cancelEvent_revertsAfterStart |

## Singleton-specific properties (beyond spec.md)

| Property | Verified by |
|---|---|
| Missing-event handling on every entry point | test_unknownEventReverts (every typed ADT-backed getter and mutator, plus checkInBatch via raw call, reverts EventNotFound), test_unknownEventZeroGetters (raw-mapping stats - attendees, cancelled, registeredCount, checkedInCount, claimedCount, held - return zero for an unknown id, mirroring Solidity public-mapping semantics; the revert-vs-zero split is deliberate) |
| Constructor rejects a zero maintainer | test_constructor_rejectsZeroMaintainer |
| Per-event isolation of status/counters/pots | test_register_isolatedAcrossEvents, test_claimDust_isolatedPerEvent |
| Organizer authority scoped per event | test_cancelEvent_organizerScopedPerEvent, test_checkIn_organizerScopedPerEvent |
| Multi-event lifecycle with shared attendee | test_integration_twoOverlappingEvents |
| Ledger consistency under fuzz (registration phase + forced ETH) | KodylInvariant.t.sol |
| Check-in rejected on cancelled event; refund stays open (review, high) | test_checkIn_rejectedAfterCancelSoRefundStaysOpen |
| Forced ETH does not brick flows (review, critical) | test_forcedETH_doesNotBrickFlows |

## checkInBatch calldata decoder (hand-rolled in the payable fallback)

`checkInBatch(uint256,address[])` is decoded from raw calldata by hand in the
fallback - it predates the lazy calldata-array decoding that landed at the
`1950e707` re-pin and stays hand-decoded deliberately (wire compat, stray-ETH
rejection, historical exhibit); these tests attack the decoder with
adversarial byte strings.

| Behavior | Verified by |
|---|---|
| Selector-only calldata: missing words read as zero, so eid decodes 0 and reverts EventNotFound | test_checkInBatch_selectorOnlyCalldata |
| Offset past calldatasize: the length word reads zero, silent no-op success | test_checkInBatch_offsetPastCalldataIsNoOp |
| All-ones offset wraps the length pointer to 3, the length word picks up selector bytes and trips the size cap: exact BatchTooLarge(len, 100) payload, not a silent no-op | test_checkInBatch_allOnesOffsetWrapsIntoBatchTooLarge |
| Nonzero upper 96 bits in an array element revert DirtyHigherBitsForAddress, matching the std decoder on typed address paths; the clean variant of the same batch succeeds | test_checkInBatch_dirtyAddressWordReverts |
| Nonzero callvalue rejected with empty revert data (the fallback's value guard) | test_checkInBatch_rejectsValueWithEmptyRevert |

## Shared-custody accounting (the core design risk)

Pooling all deposits in one balance is the singleton's central trade; these
tests attack the accounting that has to earn back per-event isolation.

| Property | Verified by |
|---|---|
| Reentrant claimant cannot double-claim (CEI + status transition) | KodylAccounting: test_reentrancy_doubleClaimGainsNothing |
| Reentrant claimDust during payout extracts nothing | test_reentrancy_claimDustGainsNothing |
| Reentrant cross-event cancel keeps all pots consistent | test_reentrancy_crossEventCancelStaysConsistent |
| Exact per-event conservation at indivisible deposits (7 wei, 100 wei, prime splits) | test_conservation_indivisible7wei, test_conservation_primeSplit |
| Reward = min(floor(noShow*deposit/checkedIn), deposit), excess rebated per no-show, dust = remainder, no wei created/lost | test_conservation_* (all six; oneCheckinManyNoShows and primeSplit exercise the rebate leg) |
| Late claim after the timeout dust-sweep reverts PayoutSwept() (clear error, no ETH conjured) | test_lateClaimAfterDustSweep_failsSafely |
| Full-lifecycle three-way ledger equality (sum(held) == totalHeld, balance == totalHeld + forced ETH) | KodylConservation: invariant_ledgerThreeWayEquality (128k calls) |
| Compiler-independent ETH conservation (in + forced - out == balance) | invariant_ethConserved (128k calls) |
| Per-event pot == its own deposits minus payouts (catches cross-event leak) | invariant_perEventConserved (128k calls) |
| Every successful claim pays exactly deposit + min(floor(noShow * deposit / checkedIn), deposit), checked per claim against an independent ghost model | invariant_claimPayoutsExact (128k calls) |
| Every successful claimNoShowRebate pays exactly the ghost-model per-no-show excess | invariant_rebatePayoutsExact (128k calls) |

The lifecycle handler is phase-aware: each action scans an independent ghost
model of the protocol for an (event, actor) pair that lets the call succeed,
falling back to a seed-derived pick so revert paths stay fuzzed; warps target
the next lifecycle boundary of a chosen event, forceEth injects unledgered
ETH, and every successful claim's balance delta is compared against the
model's expected payout (asserted by invariant_claimPayoutsExact). Scale is
pinned in foundry.toml (256 runs x 500 calls): each invariant is a 128k-call
campaign in which every handler action is dispatched roughly 12.7k times.
Per-action success counts are logged by afterInvariant (visible with -vv) as
a final-run snapshot, not asserted. Exact counts are seed-dependent; the
shape is stable: every protocol action lands single-digit-to-low-double-digit
successes per 500-call run (warpForward and forceEth succeed on every
attempt), and across a full campaign checkIn/claim/claimDust each succeed
hundreds of times - versus 1-4 per campaign before the phase-aware rework -
so reward payouts and dust sweeps are exercised within runs, not just
registration.

## Proof-based check-in (v2)

The two-signature path (`checkInWithProof`, `checkInBatchWithProofs`) and its
on-chain operator set. Digests are recomputed independently in the test
(`keccak256(abi.encode(typehash, ...))` plus the `0x1901` prefix), so a green
test also cross-checks the contract's hand-rolled hashing.

| Behavior | Verified by |
|---|---|
| Single-proof happy path, submitted by an unrelated relayer (not the organizer) | test_proofCheckIn_happyPath_submittedByAnyone |
| Proof check-in succeeds during Dispute (window is Active + Dispute) | test_proofCheckIn_succeedsDuringDispute |
| Batch succeeds at the inclusive Dispute back edge (eventEnd + disputePeriod); one second later the same proof reverts CheckInWindowClosed - the dispute gate is the sole time bound on a proof | test_proofBatch_succeedsAtDisputeBackEdge |
| Replaying a consumed proof is a silent no-op (checkedInCount unchanged) | test_proofCheckIn_replayIsSilentNoOp |
| Valid proofs for a never-registered address are a silent no-op | test_proofCheckIn_notRegisteredIsSilentSkip |
| Wrong ticket signer reverts TicketSignerMismatch | test_proofCheckIn_wrongTicketSignerReverts |
| Ticket signed for a different event reverts TicketSignerMismatch | test_proofCheckIn_ticketForOtherEventReverts |
| Self-signed / non-operator presence reverts PresenceSignerUnauthorized; a presence bound to A cannot check in B | test_proofCheckIn_unauthorizedPresenceReverts |
| Operator-signed presence checks in after setOperator | test_proofCheckIn_operatorPresence |
| A revoked operator's presence reverts PresenceSignerUnauthorized | test_proofCheckIn_revokedOperatorReverts |
| Operator management auth matrix: non-organizer reverts NotOrganizer, unknown event reverts EventNotFound, isOperator is zero-tier | test_operatorManagement_authMatrix |
| A setOperator bool word above 1 reverts DirtyHigherBitsForBool (strict decode); the clean word goes through | test_setOperator_dirtyBoolWordReverts |
| Wrong-length signature reverts InvalidSignatureLength (ticket and presence positions) | test_proofCheckIn_invalidSignatureLengthReverts |
| High-s signature reverts MalleableSignatureRejected | test_proofCheckIn_malleableHighSReverts |
| Invalid recovery (v = 0) reverts ECRecoverFailed, never a stale scratch signer (pins the upstream scratch-zeroing fix that retired the recoverStrict shim) | test_proofCheckIn_invalidRecoveryDoesNotReturnStaleSigner |
| Domain binding: a digest signed for a different verifyingContract or chainId fails signer equality | test_proofCheckIn_domainBindingRejectsForeignDigests |
| State gates: Registration / Settled / cancelled all revert CheckInWindowClosed | test_proofCheckIn_stateGates |
| Unknown event reverts EventNotFound (single and batch) | test_proofCheckIn_unknownEventReverts |
| Batch happy path mixed with an already-checked-in no-op | test_proofBatch_happyPath_mixedWithNoOp |
| One bumpCheckedIn per external call, not per attendee (no storage slot written twice) | test_proofBatch_oneBumpCheckedInPerCall |
| A bad signature reverts the whole batch atomically (an earlier valid entry is not applied) | test_proofBatch_badSignatureRevertsWholeBatch |
| Array-length mismatch reverts ProofArrayMismatch | test_proofBatch_arrayMismatchReverts |
| Over-cap batch reverts BatchTooLarge before any signature work | test_proofBatch_capBatchTooLarge |
| Empty batch is a no-op | test_proofBatch_emptyIsNoOp |

## Toolchain canaries (test/CoreProbe.t.sol)

`Probe.sol` exercises each language feature the implementation leans on;
`check-core.sh` compiles it first, so drift fails on the small labeled contract
before Kodyl. The v2 additions pin the EIP-712 / ecrecover / calldata-array
surface the proof path depends on; the new-syntax migration added the three
storage-pattern canaries at the bottom.

| Behavior | Verified by |
|---|---|
| Constructor args, dispatch, and an opcode wrapper end to end; unknown selector reverts | test_probe_ctorArgs_dispatch_and_opcode |
| require(cond, "msg") reverts RAW message bytes (not Solidity Error(string)) | test_probe_requireMessage_revertsRawBytes |
| User-defined Str instance folds a signature literal to its selector at compile time | test_probe_strInstance_foldsSelector |
| UFCS methods on a storage array of strings (push/length/index) | test_probe_ufcsStorageArray |
| Bare integer literal in a non-tail return | test_probe_bareLiteralNonTailReturn |
| std eip712 domain separator and 0x1901 digest match an independent Solidity computation | test_probe_eip712_domainSeparator_and_digest |
| Hand-rolled hashStruct via nested two-arg concat == keccak256(abi.encode(typeHash, members)) | test_probe_eip712_handRolledStructHash |
| Split-form ecrecover round-trips a vm.sign signature to the signer | test_probe_ecrecover_roundTrip |
| High-s form reverts MalleableSignatureRejected (0x25260b20) | test_probe_ecrecover_malleableHighS_reverts |
| An unrecoverable signature reverts ECRecoverFailed (0x4fbfae63) - std ecrecover never returns zero | test_probe_ecrecover_invalid_revertsFailed |
| ECRecoverCallFailed is unobservable: gas starvation is a plain OOG with empty returndata (swept window with a top-edge success assert) | test_probe_ecrecover_gasStarved_isPlainOogNotCallFailed |
| calldata<array<address>>: length, indexing, ArrayOutOfBounds (0x7f52b2bf) | test_probe_calldataAddressArray |
| calldata<array<memory<bytes>>>: dynamic elements incl. a 65-byte signature element, bounds, empty array | test_probe_calldataBytesArray |
| calldata<array<uint256>>: index, bounds, full iteration (no upstream fixture - this canary is the coverage) | test_probe_calldataUintArray |
| Enum with a struct payload as a mapping value: zero slot = first constructor, named field access on the match-bound payload | test_probe_enumStructPayloadInMapping |
| Struct as a mapping value: read-reconstruct-write update (member writes through a mapping are SC0231 at this pin) | test_probe_structMappingValueUpdate |
| ERC-7201-namespaced slots via comptime erc7201 + hash2 with raw sload/sstore: round-trip and key isolation | test_probe_namespacedSlots |

## Adversarial economics (spec.md "Trust Assumptions" / "Attack Vectors")

`test/KodylEcon.t.sol` is the executable payoff matrix behind `ECONOMICS.md`:
each strategy asserts every actor's exact ETH delta plus the footprint
counters an indexer would see. Every number in `ECONOMICS.md` resolves here.

| Claim | Test |
|---|---|
| Honest baseline: claimants get deposit + floor share, no-shows -d, remainder is dust | test_econ_honestBaseline |
| Organizer sybil capture is capped at one deposit of profit; victims rebate 90 percent; footprint 11/1/1 | test_econ_sybilCaptureBoundedToOneDeposit |
| Sybil capture profit is exactly one deposit for any victim count; victim rebates exact (fuzzed) | testFuzz_econ_sybilProfitCappedAtOneDeposit |
| Sybil skim dilutes each honest claimant vs the s=0 counterfactual | test_econ_sybilSkimsForfeitures |
| Skim share min(floor(m*d/(c+s)), d), rebate leg when capped, block total, and dust remainder (fuzzed) | testFuzz_econ_skimShareExact |
| Excluding an attendee costs the organizer nothing; victim has no recourse | test_econ_exclusionGriefingIsFree |
| Zero check-ins: abandonment refunds everyone in full, nobody profits, no sweep | test_econ_abandonmentRefundsEveryone |
| The 30-day sweep takes a sleeper's full payout, reward included | test_econ_sweepTakesUnclaimedPayouts |
| Operator-signed capture reproduces the organizer's payoffs exactly | test_econ_operatorCollusionEqualsOrganizer |
| Maintainer-as-organizer self-capture is defeated: abandonment refunds, sweep refused | test_econ_maintainerSelfCaptureDefeated |
| Capacity griefing costs only lockup; freed slots have no self-service exit | test_econ_capacityGriefingCostsOnlyLockup |
