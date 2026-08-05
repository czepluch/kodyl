# Kodyl - Adversarial Economics

The payoff matrix behind `spec.md`'s Trust Assumptions, made executable. Every
strategy below runs against the committed bytecode in `test/KodylEcon.t.sol`,
which asserts each actor's exact ETH delta and the on-chain footprint counters
an indexer would see. **Every number in this document cites a test or the
measured gas appendix; nothing here is estimated.**

## The trust model in one line

**Check-in authority is custody.** Whoever can attest presence decides where
the forfeiture pot flows, so attendees trust the organizer (and every
appointed operator) with their stake, not merely with attendance bookkeeping.

The economic fact that shapes every mitigation: **the sybil check-in attack is
nearly free.** A sybil's own deposit round-trips at claim - register, get
checked in, claim it back plus the reward - so capturing honest deposits costs
only gas (`testFuzz_econ_sybilProfitExact` pins the stake-never-at-risk
property for fuzzed turnouts and deposit sizes). Any countermeasure that
merely demands more checked-in participants (quorums, minimum ratios) fails:
sybils satisfy it at no marginal cost. The real levers are:

1. **Cap the prize** - bound what one checked-in address can extract
   (candidate C1 in `ECONOMICS-PLAN.md`).
2. **Make identity costly** - ZK attendance, attestation registries (out of
   scope, see spec's future list).
3. **Make reputation legible** - the attacks below have loud on-chain
   footprints; surface them at registration time (candidate C3).

One naming honesty note: the **dispute period grants attendees no dispute
mechanism**. It is a grace window for the organizer's late check-ins. The
aggrieved party - an attendee who was present but not checked in - has no
on-chain move: their `claim` reverts `InvalidAttendeeStatus`
(`test_econ_exclusionGriefingIsFree` proves the dead end).

## The baseline

5 register at deposit d, 3 attend and are checked in, 2 no-show
(`test_econ_honestBaseline`): each attendee's deposit round-trips plus
`floor(2d/3)` of the forfeitures; each no-show nets -d; the organizer moves no
ETH; the maintainer gets the rounding remainder (2 wei at d = 1 ETH). Every
attack row below is a deviation from this.

## Attacks

### 1. Sybil capture (organizer)

Register a sock puppet, check in only it. With 10 honest registrations at
deposit d, the sybil claims 11d: profit exactly 10d, every honest attendee
-d, and the sybil's own stake never at risk
(`test_econ_sybilCapturesWholePot`; profit is `nHonest * d` for any turnout,
`testFuzz_econ_sybilProfitExact`).

- **Cost**: gas only (appendix: register + checkIn + claim, about 198k in-EVM
  across three transactions).
- **Footprint**: `registeredCount 11 / checkedInCount 1 / claimedCount 1` -
  the loud red-flag ratio - plus a payout to an address with no history.
- **Today**: not prevented; reputational deterrence only.
- **Changed by**: C1 (profit drops from `n*d` to the cap), C3 (footprint
  becomes visible at registration time).

### 2. Sybil skim (organizer)

The subtle variant: check in the honest attendees AND s sybils. Everyone who
attended still gets paid, just less - with c honest claimants, m no-shows and
s sybils each claimant receives `floor(m*d/(c+s))` instead of `floor(m*d/c)`
(`test_econ_sybilSkimsForfeitures` runs the s = 2 case against its s = 0
counterfactual on a second event: 0.5 ETH per claimant instead of 0.75;
`testFuzz_econ_skimShareExact` pins the share, the sybil block's total
`s * floor(m*d/(c+s))`, and the dust remainder for fuzzed c, s, m, d).

- **Cost**: gas only; sybil deposits round-trip.
- **Footprint**: much quieter than capture - the checked-in ratio looks
  plausible; the tell is claimants with no cross-event history.
- **Today**: not prevented, and hard for a victim to notice (they still got
  a bonus).
- **Changed by**: C1 only in extreme regimes (the skim usually stays under
  any sane cap); C3 is the real counter.

### 3. Exclusion griefing (organizer)

Refuse to check in one attendee who was present: the victim nets -d, the
forfeiture flows to the other claimants, and the organizer's own ETH delta is
zero - the harm needs no motive and costs nothing
(`test_econ_exclusionGriefingIsFree`). Combined with a checked-in sybil it
becomes targeted capture (attack 1).

- **Cost**: zero - exclusion is the absence of a transaction.
- **Footprint**: invisible on-chain (indistinguishable from a genuine
  no-show). The victim knows; the chain does not.
- **Today**: no recourse; the dispute window helps only if the organizer
  cooperates.
- **Changed by**: nothing on the table; this is the irreducible core of
  attested check-in. C4's stake-plus-adjudication would be the counter, and
  is blocked on an adjudication design.

### 4. Abandonment (organizer)

Check in nobody. At settlement the vacuous all-claimed rule (0 == 0) makes
`claimDust` available immediately and the ENTIRE pot - not rounding dust -
goes to the maintainer: 4 registrations means the maintainer nets 4d while
every attendee eats -d with no recourse
(`test_econ_abandonmentRoutesPotToMaintainer`).

- **Cost**: zero - abandonment is doing nothing.
- **Footprint**: `checkedInCount == 0` with a nonzero `registeredCount`, then
  an immediate dust sweep. Unambiguous and highly visible.
- **Today**: not prevented. Note the organizer gains nothing directly; the
  pot goes to the maintainer - which is exactly what makes attack 6 work.
- **Changed by**: C2 (zero check-ins reclassified as abandonment: refunds
  open, no sweep - the attack becomes profitless for everyone).

### 5. Operator collusion

An appointed operator's `Presence` signature reproduces attack 1 exactly: 3
honest deposits captured through an operator-signed proof, profit 3d, and
neither the operator nor the organizer moves ETH on-chain (the split is
off-chain) (`test_econ_operatorCollusionEqualsOrganizer`). Appointing an
operator IS sharing the custody surface - the payoffs are identical.

- **Cost**: gas only (appendix: setOperator + checkInWithProof).
- **Footprint**: as attack 1, plus the `OperatorSet` log naming the operator.
- **Today**: auditable (`isOperator`, `OperatorSet`) and revocable
  (`setOperator`), but while authorized the attestation carries full weight.
- **Changed by**: C1, C3 (an operator's cross-event appointment history is a
  usable signal).

### 6. Maintainer-as-organizer self-capture

The maintainer address creates an event and abandons it (attack 4): one party
captures every deposit, 3d for 3 trusting registrants, no sybil needed
(`test_econ_maintainerAsOrganizerSelfCapture`). Nothing prevents the
maintainer from organizing events; the roles compose.

- **Cost**: zero.
- **Footprint**: the dust recipient equals the organizer - a one-line
  indexer check.
- **Today**: not prevented.
- **Changed by**: C2 closes this completely (abandonment stops routing funds
  anywhere).

### 7. The 30-day sweep takes unclaimed payouts

Protocol rule rather than attack, but an economic transfer worth pinning: a
checked-in attendee who does not claim within 30 days of settlement loses
their FULL payout - earned reward included, not just their deposit - to the
maintainer (`test_econ_sweepTakesUnclaimedPayouts`: the sleeper's 1.5d goes
to the maintainer and their late `claim` reverts `PayoutSwept`).

- **Today**: documented abandonment rule (`spec.md` Settlement). The
  maintainer profits from claimant inattention; the frontend's job is to make
  sleeping through the window hard.

### 8. Capacity griefing (attendee)

Fill a capped event's slots, cancel everything at the deadline: full refunds,
so the cost is capital lockup plus gas, while real attendees are locked out
for the whole pre-deadline window. Freed slots are only registrable in the
no-self-service-exit window between deadline and start - late registrants
cannot cancel (`test_econ_capacityGriefingCostsOnlyLockup`).

- **Cost**: lockup of `cap * d` until the deadline, plus gas (appendix:
  register + cancel per slot).
- **Footprint**: mass registrations then mass cancellations at the deadline
  from related addresses.
- **Today**: the deposit is the spam cost only in lockup terms; it is fully
  recovered. Tolerated - the damage is denial, not theft, and the organizer
  can recreate the event.

## Non-actors

- **Relayer / mailbox**: proof submission moves no funds and is
  permissionless by design - the two signatures are the authorization. No
  economic surface.
- **Front-running**: check-in transfers no value; claim pays only
  `msg.sender`. Nothing to steal by ordering.

## Summary matrix

| # | Attack | Attacker profit | Attacker cost | On-chain visibility | Status |
|---|--------|----------------|---------------|--------------------|--------|
| 1 | Sybil capture | `nHonest * d` | gas | loud (1-of-n check-in ratio) | not prevented |
| 2 | Sybil skim | `s * floor(m*d/(c+s))` | gas | quiet (plausible ratios) | not prevented |
| 3 | Exclusion griefing | 0 (harm without profit) | zero | invisible | no recourse |
| 4 | Abandonment | 0 for organizer, pot to maintainer | zero | unambiguous | not prevented |
| 5 | Operator collusion | as attack 1 | gas | as 1 + OperatorSet log | not prevented |
| 6 | Maintainer self-capture | `n * d` | zero | dust recipient == organizer | not prevented |
| 7 | Sweep of unclaimed payouts | n/a (protocol rule) | n/a | DustClaimed after timeout | documented |
| 8 | Capacity griefing | 0 (denial only) | lockup + gas | mass register/cancel | tolerated |

Profit columns are verified by the tests cited in each section; "zero cost"
means no ETH at risk and no transaction required beyond doing nothing.

## Measured gas appendix

In-EVM call gas measured with `gasleft()` deltas in a forge harness against
the committed bytecode at toolchain pin `1fb1f880` (forge's `--gas-report`
cannot attribute calls to a raw-hex deploy). Add ~21k intrinsic plus calldata
gas per transaction for an on-chain cost. Measured 2026-08-05:

| Call | Gas (in-EVM) |
|---|---|
| `register` (11th registrant) | 39,930 |
| `checkIn` (direct, single) | 74,247 |
| `checkInWithProof` (operator-signed) | 85,057 |
| `setOperator` (enable) | 29,646 |
| `claim` | 84,059 |
| `claimDust` (abandonment sweep) | 47,239 |
| `cancel` (griefer exit) | 63,409 |

At any plausible gas price these are noise next to a single 1 ETH deposit:
the economics above are dominated entirely by the deposit flows.

## What follows

The candidate mechanism changes - reward cap (C1), zero-check-in refunds
(C2), reputation surface (C3), organizer stake (C4, deprioritized until an
adjudication design exists) - are specified in `ECONOMICS-PLAN.md` Track 2,
each to be judged against this matrix. When one lands, its new payoffs get
their own `test_econ_*` rows and this document is updated in the same commit.
