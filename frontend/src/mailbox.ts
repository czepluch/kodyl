// Thin client for the phase 2 voucher mailbox. Every call is best-effort: the
// mailbox is a convenience relay, never a source of truth (the contract
// verifies), so a failure is non-fatal - the operator outbox keeps the voucher
// and direct on-chain submission still works.
import { CONTRACT, MAILBOX_URL, chain } from './config'
import type { Voucher } from './outbox'

// Fire-and-forget delivery of a signed voucher. Returns whether it landed;
// callers do not depend on it.
export async function postVoucher(v: Voucher): Promise<boolean> {
  try {
    const res = await fetch(`${MAILBOX_URL}/vouchers`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(v),
    })
    return res.ok
  } catch {
    return false
  }
}

// Self-rescue poll: the single voucher for (event, attendee), or null if the
// mailbox has none (or is unreachable). chainId + contract disambiguate the
// store key across deployments.
export async function fetchVoucher(eid: bigint, attendee: string): Promise<Voucher | null> {
  try {
    const url = new URL(`${MAILBOX_URL}/vouchers`)
    url.searchParams.set('eventId', eid.toString())
    url.searchParams.set('attendee', attendee)
    url.searchParams.set('chainId', String(chain.id))
    url.searchParams.set('contract', CONTRACT)
    const res = await fetch(url)
    if (!res.ok) return null
    return (await res.json()) as Voucher
  } catch {
    return null
  }
}
