# Kodyl

> Decentralized event management with skin-in-the-game incentives

## Overview

Kodyl is a decentralized event management protocol where attendees stake a small deposit when registering for an event. Show up and get your deposit back (plus a share of no-show deposits). Don't show up? You lose your stake.

**Key Features:**
- Deposit-based registration with automatic refund for attendees
- Pro-rata distribution of no-show deposits to attendees
- Dispute period for late check-in approvals
- Configurable cancellation deadlines
- Factory pattern (one contract per event) for isolation and security

## Inspiration

This project is heavily inspired by [Kickback](https://kickback.events/), which pioneered the concept of stake-based event attendance. Kickback was a brilliant idea that solved real problems around event no-shows using blockchain incentives.

Kodyl is a learning experiment and tribute to Kickback - reimagining the concept with:
- Educational focus on Solidity best practices
- Open-source public good approach
- Simplified architecture for clarity and security
- Potential to build something useful while honoring the original vision

## Documentation

For detailed technical specification, architecture decisions, data models, and security considerations, see [spec.md](./spec.md).

## Development

This project uses [Foundry](https://book.getfoundry.sh/) for Ethereum smart contract development.

### Build

```shell
forge build
```

### Test

```shell
forge test
```

### Format

```shell
forge fmt
```

### Gas Snapshots

```shell
forge snapshot
```

## License

MIT (pending - to be added)
