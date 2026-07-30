// EIP-712 typed-data definitions for proof-based check-in. The domain and the
// two struct type layouts are the wire contract with the Kodyl contract: the
// type strings viem derives from these objects
// ("Ticket(uint256 eventId)" and
//  "Presence(uint256 eventId,address attendee,uint256 validUntil)")
// must byte-match the contract's keccakLit literals in core/Kodyl.solc, and the
// domain must match its domainSep (name "Kodyl", version "1", the deployment's
// chain id and address). test/Kodyl.t.sol pins the same strings independently.
import { CONTRACT, chain } from './config'

export const DOMAIN = {
  name: 'Kodyl',
  version: '1',
  chainId: chain.id,
  verifyingContract: CONTRACT,
} as const

// The attendee is deliberately NOT in the Ticket message: the contract recovers
// the signer and requires it to equal the attendee argument, so the signature
// itself is the binding.
export const TICKET_TYPES = {
  Ticket: [{ name: 'eventId', type: 'uint256' }],
} as const

export const PRESENCE_TYPES = {
  Presence: [
    { name: 'eventId', type: 'uint256' },
    { name: 'attendee', type: 'address' },
    { name: 'validUntil', type: 'uint256' },
  ],
} as const
