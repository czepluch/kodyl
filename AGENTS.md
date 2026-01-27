# Kodyl - Agent Guidelines

## Project Purpose

Kodyl is a decentralized event management protocol with skin-in-the-game incentives. Attendees stake deposits when registering; they get deposits back (plus rewards from no-shows) if they attend.

**Key goals:**
- Educational project showcasing Solidity best practices
- Open-source public good
- Simplicity and security above all else

## Architecture Overview

```
contracts/
├── KodylFactory.sol  # Deploys event contracts
├── KodylEvent.sol    # One instance per event
└── interfaces/
    └── IKodylEvent.sol

test/
├── unit/                    # Per-function tests
├── invariant/               # Fuzz tests for invariants
└── integration/             # Full lifecycle tests
```

## Key Invariants

These MUST always hold - test aggressively:

1. `address(this).balance == registeredCount * depositAmount + dust`
2. No double claims
3. No refunds after cancellation deadline
4. Settlement only after dispute period ends
5. Check-ins only during valid window

## Coding Standards

### Solidity

- Target version: 0.8.33
- Use custom errors (not require strings)
- NatSpec on all public/external functions
- Follow FREI-PI pattern for all state-changing functions
- CEI (Checks-Effects-Interactions) for reentrancy protection

### Testing

- Use Foundry/Forge exclusively
- Run `forge fmt` before committing
- Invariant tests are critical - every invariant needs fuzz coverage
- Test edge cases: exactly at deadlines, capacity limits, zero attendees

### Security

- No `tx.origin` for auth
- External calls always last
- No unbounded loops
- Document trust assumptions in comments

## Event Lifecycle States

States are **derived from timestamps**, not stored:

```
Registration → Active → Dispute → Settled
     ↓
 Cancelled (if organizer cancels before event starts)
```

```solidity
function getState() public view returns (State) {
    if (cancelled) return State.Cancelled;
    if (block.timestamp < eventStart) return State.Registration;
    if (block.timestamp <= eventEnd) return State.Active;
    if (block.timestamp <= eventEnd + disputePeriod) return State.Dispute;
    return State.Settled;
}
```

## Current Scope (MVP)

- Factory pattern (one contract per event)
- ETH deposits only
- Manual check-in by organizer only (single + batch, max 100 per batch)
- Pro-rata no-show distribution
- Dispute period for late approvals
- Configurable cancellation deadline (min 2h before event)
- Individual `claim()` and batch `settleAll()`
- `claimDust()` to project maintainer

## Out of Scope (Future)

- ERC20 tokens
- DeFi yield integrations
- Alternative distribution (lottery, annual payout)
- DAO governance
- Privacy features (ZK proofs)
- Protocol fees
- Self-check-in (too easy to share with friends)

## Networks

- **Development/Testing**: Sepolia
- **Production**: Mainnet, major L2s (future)

## Reference

See `spec.md` for full specification including data models, security considerations, and frontend requirements.
