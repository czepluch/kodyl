# spec.md coverage map

Every mechanic and invariant in `spec.md` mapped to the tests that verify it
against the compiled Core Solidity bytecode (`test/core/Kodyl.t.sol` unless
noted).

## Core mechanics

| spec.md mechanic | Verified by |
|---|---|
| Organizer creates event with params | test_createEvent_sequentialIdsAndStorage, test_createEvent_emits |
| Parameter validation (deposit > 0, future start, end after start, deadline min 2h before event and in future, dispute period 1h..30d) | test_validation_reverts, test_validation_deadlineBoundary |
| Attendees register with exact deposit | test_register_happyPath, test_register_revertsOnWrongDeposit |
| Capacity cap (0 = unlimited) | test_register_revertsWhenFull |
| Registration closes at event start | test_register_revertsAfterStart |
| Cancel before deadline: immediate refund | test_cancel_refundsAndUpdatesLedger |
| No refund after deadline | test_cancel_revertsAfterDeadline |
| Re-registration after cancellation | test_register_reRegisterAfterCancel |
| Organizer cancels event before start: full refunds | test_cancelEvent_lifecycle, test_claimRefund_afterCancelEvenPastDeadline |
| No event cancellation after start | test_cancelEvent_revertsAfterStart |
| Check-in by organizer, single + batch (max 100), invalid entries skipped | test_checkIn_happyAndSkip, test_checkInBatch_throughTypedInterface, test_checkInBatch_revertsWhenTooLarge |
| Check-in window: eventStart through eventEnd + disputePeriod | test_checkIn_revertsOutsideWindow, test_getState_transitionsOverTime |
| Pull-only claims after dispute period | test_claim_paysDepositPlusReward, test_claim_revertsBeforeSettledAndWhenNotCheckedIn |
| Pro-rata no-show distribution + reward math | test_claim_paysDepositPlusReward (3 reg / 2 checked / 0.5 ETH each) |
| Dust to maintainer after all claims or timeout | test_claimDust_remainderAfterAllClaims, test_claimDust_gatesAndTimeout |
| Zero check-ins: everything to dust | test_claimDust_zeroCheckInsAllToDust |
| Reject unexpected ETH | test_fallback_rejectsPlainTransferAndUnknownSelector |
| Mutable metadata URI with event | test_setMetadataURI |
| Maintainer management | test_setMaintainer |

## Attendee status transitions (spec.md "Valid transitions")

| Transition | Verified by |
|---|---|
| None -> Registered | test_register_happyPath |
| Registered -> Cancelled (cancel) | test_cancel_refundsAndUpdatesLedger |
| Registered -> Cancelled (claimRefund) | test_claimRefund_afterCancelEvenPastDeadline |
| Registered -> CheckedIn | test_checkIn_happyAndSkip |
| Cancelled -> Registered | test_register_reRegisterAfterCancel |
| CheckedIn -> Claimed | test_claim_paysDepositPlusReward |
| Claimed terminal / invalid transitions revert | test_register_revertsWhenAlreadyRegistered, test_cancel_revertsWhenNotRegistered, test_claimRefund double-refund assert |

## spec.md invariants

| # | Invariant | Verified by |
|---|---|---|
| 1 | Deposit accounting: balance == deposits held (+ dust) | KodylInvariant.t.sol (128k calls, 3 events, per-event and global ledgers) + in-contract solAssert after every ETH movement |
| 2 | No double claims (Claimed terminal) | test_claim_* (second claim reverts InvalidAttendeeStatus(4, 3) path), test_claimRefund double-refund |
| 3 | No post-deadline cancellation | test_cancel_revertsAfterDeadline |
| 4 | Claims only after dispute period | test_claim_revertsBeforeSettledAndWhenNotCheckedIn |
| 5 | Check-in window enforced | test_checkIn_revertsOutsideWindow |
| 6 | Event cancellation only before start | test_cancelEvent_revertsAfterStart |

## Singleton-specific properties (beyond spec.md)

| Property | Verified by |
|---|---|
| Missing-event handling on every entry point | test_unknownEventReverts |
| Per-event isolation of status/counters/pots | test_register_isolatedAcrossEvents, test_claimDust_isolatedPerEvent |
| Organizer authority scoped per event | test_cancelEvent_organizerScopedPerEvent, test_checkIn_organizerScopedPerEvent |
| Multi-event lifecycle with shared attendee | test_integration_twoOverlappingEvents |
| Ledger consistency under fuzz (registration phase) | KodylInvariant.t.sol |
| Check-in rejected on cancelled event; refund stays open (review, high) | test_checkIn_rejectedAfterCancelSoRefundStaysOpen |
| Forced ETH does not brick flows (review, critical) | test_forcedETH_doesNotBrickFlows |

## Shared-custody accounting (the core design risk)

Pooling all deposits in one balance is the singleton's central trade; these
tests attack the accounting that has to earn back per-event isolation.

| Property | Verified by |
|---|---|
| Reentrant claimant cannot double-claim (CEI + status transition) | KodylAccounting: test_reentrancy_doubleClaimGainsNothing |
| Reentrant claimDust during payout extracts nothing | test_reentrancy_claimDustGainsNothing |
| Reentrant cross-event cancel keeps all pots consistent | test_reentrancy_crossEventCancelStaysConsistent |
| Exact per-event conservation at indivisible deposits (7 wei, 100 wei, prime splits) | test_conservation_indivisible7wei, test_conservation_primeSplit |
| Reward = floor(noShow*deposit/checkedIn), dust = remainder, no wei created/lost | test_conservation_* (all six) |
| Late claim after the timeout dust-sweep reverts PayoutSwept() (clear error, no ETH conjured) | test_lateClaimAfterDustSweep_failsSafely |
| Full-lifecycle three-way ledger equality (balance == totalHeld == sum(held)) | KodylConservation: invariant_ledgerThreeWayEquality (128k calls) |
| Compiler-independent ETH conservation (in - out == balance) | invariant_ethConserved (128k calls) |
| Per-event pot == its own deposits minus payouts (catches cross-event leak) | invariant_perEventConserved (128k calls) |

The lifecycle invariants fuzz register / cancel / claimRefund / check-in /
claim / dust / cancelEvent with time advancing across three concurrent events
of different (and indivisible) deposits; all eight actions fire ~16k times per
run, so reward payouts and dust sweeps are genuinely exercised, not just
registration.
