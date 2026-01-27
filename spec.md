# Kodyl - Decentralized Event Management

> Skin in the game incentives for event attendance.

## Overview

Kodyl is a decentralized event management protocol where attendees stake a small deposit when signing up for an event. Show up and get your deposit back (plus a share of no-show deposits). Don't show up without canceling? You lose your stake.

This is a reimplementation/evolution of [Kickback](https://kickback.events/), designed as an educational open-source public good.

## Core Mechanics

### Happy Path

1. **Organizer creates event** - Sets deposit amount, cancellation deadline, event time, capacity
2. **Attendees register** - Stake the required deposit
3. **Event happens** - Attendees check in (verified by organizer)
4. **Settlement** - Attendees claim deposits + pro-rata share of no-show deposits

### Cancellation

- Attendees can cancel and get their deposit back **immediately** up until the cancellation deadline
- Cancellation deadline is configurable per event (minimum: 2 hours before event)
- After deadline: no refund unless event is cancelled by organizer
- Re-registration after cancellation is allowed (requires new deposit)

### No-Shows

- Attendees who neither cancel nor check in forfeit their deposit
- Forfeited deposits are distributed pro-rata among checked-in attendees
- If nobody checks in, all forfeited deposits go to dust (claimable by project maintainer)

### Event Cancellation

- Organizer can cancel the entire event, triggering full refunds for all registered attendees
- Event cancellation only allowed **before event starts** (`block.timestamp < eventStart`)
- After event starts, organizer cannot cancel (only individual claims after dispute period)

## Architecture

### Contract Structure

**Factory Pattern** - One contract per event for isolation and simplicity.

```
KodylFactory
├── Creates KodylEvent instances
├── Tracks deployed events
├── Stores project maintainer address (for dust claims)
└── Holds reference implementation version

KodylEvent (one per event)
├── Handles registrations
├── Manages check-ins
├── Processes cancellations
└── Distributes deposits at settlement
```

**Rationale:**
- Bug isolation - issues in one event don't affect others
- Simpler state management - no complex nested mappings
- Clear upgrade path - new events use new template, old events unaffected
- Gas efficiency - smaller contract state to read/write

### Roles

**Organizer** (per-event admin)
- Creates event with parameters
- Checks in attendees (single or batch)
- Can cancel event before it starts (full refunds to all)
- Can approve late check-ins during dispute period

**Attendee**
- Registers with deposit
- Can cancel before deadline (immediate refund)
- Can re-register after cancellation
- Claims deposit + rewards after dispute period ends

## Event Lifecycle

### Timestamp-Derived State

Instead of storing an explicit state enum, the event state is **derived from timestamps**. This eliminates state transition bugs and reduces storage.

```solidity
function getState() public view returns (State) {
    if (cancelled) return State.Cancelled;
    if (block.timestamp < eventStart) return State.Registration;
    if (block.timestamp <= eventEnd) return State.Active;
    if (block.timestamp <= eventEnd + disputePeriod) return State.Dispute;
    return State.Settled;
}
```

### States and Allowed Actions

| State | Condition | Actions Allowed |
|-------|-----------|-----------------|
| `Registration` | `now < eventStart` | Register, cancel (before deadline), organizer cancel event |
| `Active` | `eventStart <= now <= eventEnd` | Check-ins |
| `Dispute` | `eventEnd < now <= eventEnd + disputePeriod` | Late check-ins by organizer |
| `Settled` | `now > eventEnd + disputePeriod` | Claims, dust withdrawal |
| `Cancelled` | `cancelled == true` | Refund claims only |

### Capacity

Registration closes automatically when `registeredCount == maxAttendees` (if `maxAttendees > 0`). No explicit "close registration" action needed.

## Data Model

### Event Parameters (set at creation)

| Field | Type | Mutable | Notes |
|-------|------|---------|-------|
| `organizer` | `address` | No | Event creator, has admin rights |
| `depositAmount` | `uint256` | No | Required stake in wei |
| `cancellationDeadline` | `uint256` | No | Timestamp, min 2h before event |
| `eventStart` | `uint256` | No | Event start timestamp |
| `eventEnd` | `uint256` | No | Event end timestamp |
| `disputePeriod` | `uint256` | No | Duration after event end (default 24h) |
| `maxAttendees` | `uint256` | No | Capacity cap (0 = unlimited) |
| `metadataURI` | `string` | Yes | IPFS hash or URL (emits event on change) |
| `cancelled` | `bool` | Once | Set true by organizer cancel |

### Attendee Status

Use an enum to prevent invalid state transitions:

```solidity
enum AttendeeStatus {
    None,       // Never registered
    Registered, // Deposited, not yet checked in
    Cancelled,  // Cancelled before deadline, got refund
    CheckedIn,  // Verified attendance
    Claimed     // Already claimed payout
}

mapping(address => AttendeeStatus) public attendees;
```

**Valid transitions:**
- `None → Registered` (register)
- `Registered → Cancelled` (cancel before deadline)
- `Registered → CheckedIn` (organizer check-in)
- `Cancelled → Registered` (re-register with new deposit)
- `CheckedIn → Claimed` (claim payout)

**Invalid transitions (revert):**
- `Claimed → anything` (no re-registration after claiming)
- `CheckedIn → Cancelled` (can't cancel after check-in)

### Counters

| Counter | Updated By |
|---------|------------|
| `registeredCount` | +1 on register, -1 on cancel |
| `checkedInCount` | +1 on check-in |
| `claimedCount` | +1 on claim |

Note: `registeredCount` tracks *current* registered attendees (not historical). Cancelled attendees are subtracted.

### Computed at Settlement

| Value | Calculation |
|-------|-------------|
| No-shows | `registeredCount - checkedInCount` (at settlement time) |
| Total forfeited | `noShowCount * depositAmount` |
| Reward per attendee | `checkedInCount > 0 ? totalForfeited / checkedInCount : 0` |
| Attendee payout | `depositAmount + rewardPerAttendee` |
| Dust | `totalForfeited % checkedInCount` |

## Check-in

### Methods

Two methods for organizer check-in:

1. **Single check-in** - `checkIn(address attendee)`: Check in one attendee
2. **Batch check-in** - `checkInBatch(address[] calldata attendees)`: Check in multiple attendees

### Batch Check-in Constraints

- Maximum 100 attendees per batch (prevents gas limit issues)
- Skips invalid attendees (not registered, already checked in) without reverting
- Emits individual `CheckedIn` event per attendee for indexing

```solidity
uint256 public constant MAX_BATCH_SIZE = 100;
error BatchTooLarge(uint256 size, uint256 max);

function checkInBatch(address[] calldata attendees) external onlyOrganizer {
    if (attendees.length > MAX_BATCH_SIZE) revert BatchTooLarge(attendees.length, MAX_BATCH_SIZE);
    for (uint256 i = 0; i < attendees.length; ++i) {
        _checkIn(attendees[i]); // skips if not registered or already checked in
    }
}
```

### Check-in Window

Check-ins are valid from `eventStart` through `eventEnd + disputePeriod`. This allows organizers to approve late check-ins for attendees who were present but missed the check-in window.

## Settlement

### Claiming (Pull Pattern)

Attendees claim their own payout after the dispute period ends:

```solidity
function claim() external {
    require(getState() == State.Settled, "Not settled");
    require(attendees[msg.sender] == AttendeeStatus.CheckedIn, "Not eligible");
    
    attendees[msg.sender] = AttendeeStatus.Claimed;
    claimedCount++;
    
    uint256 payout = depositAmount + rewardPerAttendee();
    payable(msg.sender).transfer(payout);
}
```

**Why pull-only (no `settleAll()`):**
- Gas-safe: no risk of hitting block gas limit with large attendee lists
- Simpler: no pagination logic needed
- Fair: each attendee pays their own gas

### Dust Handling

Due to integer division, some wei may remain after all claims. Example:
- 3 attendees checked in
- 10 wei forfeited from no-shows
- Each gets 3 wei reward (10 / 3 = 3)
- 1 wei dust remains (10 % 3 = 1)

`claimDust()` can be called by anyone after all eligible attendees have claimed (or after a timeout). Dust is sent to the project maintainer address stored in the factory.

```solidity
function claimDust() external {
    require(getState() == State.Settled, "Not settled");
    require(claimedCount == checkedInCount || block.timestamp > eventEnd + disputePeriod + 30 days, "Claims pending");
    
    uint256 dust = address(this).balance;
    payable(factory.maintainer()).transfer(dust);
}
```

### Zero Check-ins Edge Case

If nobody checks in (`checkedInCount == 0`):
- `rewardPerAttendee` would divide by zero
- All forfeited deposits become dust
- `claimDust()` sends everything to project maintainer

## Invariants

These MUST hold true at all times - test with fuzzing:

1. **Deposit accounting**: Contract balance equals expected deposits plus dust
   - `address(this).balance == registeredCount * depositAmount + dust`
   - Note: Use `receive() external payable { revert(); }` to reject random ETH sends

2. **No double claims**: `Claimed` status is terminal (no transitions out)

3. **No post-deadline cancellation**: Cancel reverts if `block.timestamp > cancellationDeadline`

4. **Claims only after dispute period**: `claim()` reverts unless `getState() == Settled`

5. **Check-in window enforced**: Check-ins revert outside `eventStart` to `eventEnd + disputePeriod`

6. **Event cancellation window**: `cancelEvent()` reverts if `block.timestamp >= eventStart`

## Security Considerations

### FREI-PI Pattern

All state-changing functions follow:
- **F**unction requirements (validate inputs, check state)
- **E**ffects (update state)
- **I**nteractions (external calls last - CEI)
- **P**rotocol **I**nvariants (verify at end)

### ETH Handling

- Reject unexpected ETH: `receive() external payable { revert(); }`
- All ETH transfers use CEI pattern
- Consider ReentrancyGuard on `claim()` and `cancel()`

### Trust Assumptions

- Organizer is trusted to honestly verify attendance
- Organizer cannot steal deposits (can only approve check-ins or cancel event)
- Organizer cannot modify deposit amount after event creation
- Organizer cannot cancel event after it starts

### Attack Vectors

| Attack | Mitigation |
|--------|------------|
| Organizer marks fake attendees | Economic: reputation at stake. Future: require organizer stake |
| Front-running check-ins | Not profitable - check-in doesn't transfer value |
| Reentrancy on claim | CEI pattern + ReentrancyGuard |
| Griefing via spam registrations | Deposit itself is spam protection |
| Random ETH sent to contract | Rejected by `receive()`, keeps accounting clean |

## MVP Scope

### In Scope

- [x] Factory contract for deploying events
- [x] Event contract with timestamp-derived lifecycle
- [x] ETH deposits (native currency)
- [x] Attendee status enum (None/Registered/Cancelled/CheckedIn/Claimed)
- [x] Registration with capacity limit
- [x] Cancellation with immediate refund (before deadline)
- [x] Re-registration after cancellation
- [x] Manual check-in by organizer only (single and batch, max 100)
- [x] Pro-rata distribution of no-show deposits
- [x] Dispute period for late check-in approval
- [x] Event cancellation with full refunds (before event starts only)
- [x] Pull-only claims (no `settleAll()`)
- [x] `claimDust()` to project maintainer
- [x] IPFS metadata URI (mutable, emits event on change)
- [x] Reject random ETH sends

### Out of Scope (Future Enhancements)

- [ ] ERC20 token deposits
- [ ] DeFi integrations (yield on deposits via PoolTogether, Aave, etc.)
- [ ] Alternative distribution models:
  - Lottery (lucky winner takes all no-show pool)
  - Annual yield payout (deposits earn yield, distributed periodically)
  - Weighted distribution (early registrants get more)
- [ ] DAO governance for protocol-level decisions
- [ ] Protocol fees
- [ ] Privacy features (ZK proofs for attendance without revealing identity)
- [ ] Self-check-in via QR code / signed message (too easy to share with friends)
- [ ] Reputation/history tracking across events
- [ ] POAP integration (auto-distribute POAPs to checked-in attendees via POAP API)
- [ ] Multi-sig organizer support

---

## Frontend Requirements

> Note: Frontend is a separate repository. This section defines the interface requirements.

### Core Views

**Event Discovery**
- List of upcoming events
- Filter by date, location (from metadata), deposit amount
- Search by name/description

**Event Detail**
- Event metadata (name, description, location, time)
- Deposit amount and current attendee count
- Registration status and actions
- Countdown to cancellation deadline
- Clear state indication (Registration / Active / Dispute / Settled)
- **Future**: Gated content visible only to registered attendees

**Organizer Dashboard**
- Create new event form
- Attendee list with check-in controls
- Bulk check-in option (up to 100 at a time)
- Event cancellation (only shown before event starts)

**Attendee Dashboard**
- My registered events
- Claim available rewards
- Registration/cancellation history

### State Communication

The frontend must clearly communicate:
- Current event state and what actions are available
- Why claims aren't available during dispute period ("Organizer can still approve late check-ins")
- Countdown timers for deadline and dispute period end

### Wallet Integration

- Support major wallets (MetaMask, WalletConnect, Coinbase Wallet)
- Clear transaction previews before signing
- Handle network switching (Sepolia for testing, mainnet/L2s for production)

---

## Testing Strategy

### Unit Tests

- All state transitions via timestamp manipulation
- Access control on all functions
- Edge cases:
  - Exactly at deadlines (boundary conditions)
  - Capacity limits (register at max, one over)
  - Zero attendees, zero check-ins
  - Re-registration after cancellation

### Invariant Tests

Fuzz testing to verify invariants hold under random sequences of:
- Registrations
- Cancellations  
- Re-registrations
- Check-ins (single and batch)
- Claims
- Time warps

### Integration Tests

- Full event lifecycle happy path
- Event cancellation scenarios
- Dispute period resolution
- Dust claiming (all claimed vs timeout)
- Zero check-in edge case

### Deployment

- Sepolia testnet for development and testing
- Document deployment addresses and verification

---

## References

- [Kickback (original implementation)](https://kickback.events/)
- [PoolTogether (prize savings protocol)](https://pooltogether.com/)
- [The Pragmatic Programmer - Tracer Bullets](https://pragprog.com/titles/tpp20/the-pragmatic-programmer-20th-anniversary-edition/)
