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
| Ledger consistency under fuzz | KodylInvariant.t.sol |
| Check-in rejected on cancelled event; refund stays open (review, high) | test_checkIn_rejectedAfterCancelSoRefundStaysOpen |
| Forced ETH does not brick flows (review, critical) | test_forcedETH_doesNotBrickFlows |
