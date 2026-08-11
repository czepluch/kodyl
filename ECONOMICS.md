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
nearly free to mount.** A sybil's own deposit round-trips at claim - register,
get checked in, claim it back plus the reward - so the attempt costs only gas
(`testFuzz_econ_sybilProfitCappedAtOneDeposit` pins the stake-never-at-risk
property for fuzzed turnouts and deposit sizes). Any countermeasure that
merely demands more checked-in participants (quorums, minimum ratios) fails:
sybils satisfy it at no marginal cost. That is why the landed defense caps
the prize instead of taxing the attempt. The real levers are:

1. **Cap the prize** - bound what one checked-in address can extract
   (LANDED as the reward cap: `REWARD_CAP_MULTIPLE` = 1 deposit, excess
   rebated to no-shows).
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

### 1. Sybil capture (organizer) - BOUNDED by C1

Register a sock puppet, check in only it: the fake-event scam's payday.
Before the cap this took the whole pot (`nHonest * d` profit). Now the reward
caps at one deposit, so with 10 honest registrations the sybil claims 2d -
profit exactly d - and the capped-off 9d rebates to the victims, who each
recover 90 percent (`test_econ_sybilCaptureBoundedToOneDeposit`). The bound
is turnout-independent: profit is exactly one deposit for ANY victim count
and deposit size, and aggregate victim loss equals it
(`testFuzz_econ_sybilProfitCappedAtOneDeposit`).

- **Cost**: gas only, but the REAL cost was never gas - it is credibly
  marketing a fake event. At one deposit of revenue per fake event, the scam
  does not scale and does not pay.
- **Footprint**: `registeredCount 11 / checkedInCount 1 / claimedCount 1` -
  the loud red-flag ratio - plus a payout to an address with no history, and
  now a trail of RebateClaimed logs.
- **Residual**: one deposit per event, and the attestation power itself
  (attack 3's exclusion remains free). C3 makes the footprint visible at
  registration time.

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
  a bonus). The cap rarely touches it: a plausible-looking skim stays under
  one deposit per claimant by construction. C3 is the real counter.

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

### 4. Abandonment (organizer) - DEFUSED by C2

Check in nobody. Before C2 landed, the vacuous all-claimed rule (0 == 0)
made `claimDust` available immediately at settlement and the ENTIRE pot went
to the maintainer. Now a zero-check-in settlement is abandonment: `claimDust`
refuses it outright (even past the 30-day timeout - otherwise the maintainer
could race the refunds), `claimRefund` opens to every registered attendee and
never expires, and every actor nets exactly zero
(`test_econ_abandonmentRefundsEveryone`). The refund gate opens only at
Settled; a single late check-in during Dispute flips the event into normal
settlement (`test_claimRefund_abandonmentClosedByLateCheckIn`,
`test_claimRefund_zeroCheckInAbandonment` in the main suite).

- **Cost**: zero, and so is the take: abandonment now achieves nothing.
- **Footprint**: `checkedInCount == 0` with a nonzero `registeredCount`.
- **Residual**: a fake event that wants profit must check in a sybil, which
  is attack 1 - louder on-chain and bounded by C1 once that lands.

### 5. Operator collusion - BOUNDED by C1

An appointed operator's `Presence` signature reproduces attack 1 exactly,
cap included: an operator-attested sybil claims 2d against 3 honest
registrations (profit d), the victims claim their rebates, and neither the
operator nor the organizer moves ETH on-chain (the split is off-chain)
(`test_econ_operatorCollusionEqualsOrganizer`). Appointing an operator IS
sharing the custody surface - the payoffs are identical, bound included.

- **Cost**: gas only (appendix: setOperator + checkInWithProof).
- **Footprint**: as attack 1, plus the `OperatorSet` log naming the operator.
- **Residual**: as attack 1. C3 can use an operator's cross-event appointment
  history as a signal.

### 6. Maintainer-as-organizer self-capture - DEFUSED by C2

The maintainer address creates an event and abandons it (attack 4). Before
C2 this was one-party capture of every deposit with no sybil needed; now the
sweep is refused, the pot refunds in full, and the self-capture nets exactly
nothing (`test_econ_maintainerSelfCaptureDefeated`). The rational scammer's
remaining move is a checked-in sybil - attack 1's economics and footprint.

- **Cost**: zero, take: zero.
- **Residual**: as attack 4.

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
| 1 | Sybil capture | exactly `d` (was `nHonest * d`) | gas + fake-event marketing | loud (1-of-n ratio + rebate trail) | bounded (C1) |
| 2 | Sybil skim | `s * min(floor(m*d/(c+s)), d)` | gas | quiet (plausible ratios) | not prevented |
| 3 | Exclusion griefing | 0 (harm without profit) | zero | invisible | no recourse |
| 4 | Abandonment | 0 - full refunds | zero | unambiguous | defused (C2) |
| 5 | Operator collusion | as attack 1 | gas | as 1 + OperatorSet log | bounded (C1) |
| 6 | Maintainer self-capture | 0 - full refunds | zero | checkedInCount 0 | defused (C2) |
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

The candidate mechanism changes are specified in `ECONOMICS-PLAN.md` Track 2
and land one commit at a time, each with its new `test_econ_*` payoff rows
and an update to this document:

- **C2 zero-check-in refunds: LANDED** (attacks 4 and 6 defused above).
- **C1 reward cap: LANDED** (`REWARD_CAP_MULTIPLE` = 1, excess rebated to
  no-shows via `claimNoShowRebate` - attacks 1 and 5 bounded to one deposit
  of profit per event). The accepted trade: no-shows receive partial mercy in
  extreme-forfeiture events, softening the forfeiture threat exactly where
  force majeure is likeliest.
- **C3 reputation surface** (frontend): accepted, next up.
- **C4 organizer stake**: deprioritized until an adjudication design exists.
