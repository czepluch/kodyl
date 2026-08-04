// localStorage-backed voucher stores, namespaced by chain id + contract so a
// deployment swap never crosses wires. Two independent namespaces:
//  - ticket: my own signed Ticket, cached so "Show ticket" is a one-time sign.
//  - outbox: the operator's signed-but-unsubmitted Presence vouchers, kept
//    until the submission confirms or the roster shows the attendee CheckedIn.
// All bigints are serialized as decimal strings (the repo convention), so
// everything stored here is plain strings.
import { CONTRACT, chain } from './config'

const NS = 'kodyl'
const CHAIN = String(chain.id)
const CONTRACT_L = CONTRACT.toLowerCase()

export type TicketVoucher = { eventId: string; attendee: string; ticketSig: string }

// The full pair a submitter needs on-chain (mirrors the mailbox voucher shape).
export type Voucher = {
  eventId: string
  attendee: string
  ticketSig: string
  presenceSig: string
  chainId: string
  contract: string
}

const safeGet = (k: string): string | null => {
  try {
    return localStorage.getItem(k)
  } catch {
    return null
  }
}
const safeSet = (k: string, v: string): void => {
  try {
    localStorage.setItem(k, v)
  } catch {
    // Private mode / quota / disabled storage: caching is best-effort, so a
    // failure just means the next "Show ticket" re-signs.
  }
}

// --- my ticket signatures ---

const ticketKey = (eid: bigint, addr: string) => `${NS}.ticket.${CHAIN}.${CONTRACT_L}.${eid}.${addr.toLowerCase()}`

export function saveTicket(v: TicketVoucher): void {
  safeSet(ticketKey(BigInt(v.eventId), v.attendee), JSON.stringify(v))
}

export function loadTicket(eid: bigint, addr: string): TicketVoucher | null {
  const raw = safeGet(ticketKey(eid, addr))
  if (!raw) return null
  try {
    return JSON.parse(raw) as TicketVoucher
  } catch {
    return null
  }
}

// --- operator outbox ---

const outboxKey = () => `${NS}.outbox.${CHAIN}.${CONTRACT_L}`

function readOutbox(): Voucher[] {
  const raw = safeGet(outboxKey())
  if (!raw) return []
  try {
    const arr = JSON.parse(raw)
    return Array.isArray(arr) ? (arr as Voucher[]) : []
  } catch {
    return []
  }
}

function writeOutbox(list: Voucher[]): void {
  safeSet(outboxKey(), JSON.stringify(list))
}

const sameTarget = (v: Voucher, eid: string, attendee: string) =>
  v.eventId === eid && v.attendee.toLowerCase() === attendee.toLowerCase()

// One pending voucher per (event, attendee): a re-scan overwrites.
export function addToOutbox(v: Voucher): void {
  const list = readOutbox().filter((x) => !sameTarget(x, v.eventId, v.attendee))
  list.push(v)
  writeOutbox(list)
}

export function outboxFor(eid: bigint): Voucher[] {
  return readOutbox().filter((v) => v.eventId === eid.toString())
}

export function removeFromOutbox(eid: bigint, attendee: string): void {
  writeOutbox(readOutbox().filter((v) => !sameTarget(v, eid.toString(), attendee)))
}
