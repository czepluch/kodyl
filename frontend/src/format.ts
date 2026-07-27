// Display helpers shared across the UI.
import { formatEther } from 'viem'

// Mirrors the contract's DUST_CLAIM_TIMEOUT (30 days, in seconds): once
// eventEnd + disputePeriod + this has passed, claimDust may sweep the whole
// remaining pot even with payouts still unclaimed. Before that it requires
// claimedCount == checkedInCount.
export const DUST_CLAIM_TIMEOUT = 2592000

export function fmtTime(ts: bigint | number): string {
  return new Date(Number(ts) * 1000).toLocaleString()
}

// Human duration for a countdown, e.g. "2d 4h", "37m 12s", "now".
export function fmtDuration(secs: number): string {
  if (secs <= 0) return 'now'
  const d = Math.floor(secs / 86400)
  const h = Math.floor((secs % 86400) / 3600)
  const m = Math.floor((secs % 3600) / 60)
  const s = secs % 60
  if (d > 0) return `${d}d ${h}h`
  if (h > 0) return `${h}h ${m}m`
  if (m > 0) return `${m}m ${s}s`
  return `${s}s`
}

// Readable ETH: tiny integer-division outputs (dust) show as wei rather than
// "0.000000000000000333 ETH".
export function fmtEth(wei: bigint): string {
  if (wei === 0n) return '0 ETH'
  if (wei < 1_000_000_000_000n) return `${wei.toString()} wei`
  const n = Number(formatEther(wei))
  return `${n.toLocaleString(undefined, { maximumFractionDigits: 6 })} ETH`
}

export function shortAddr(a: string): string {
  return `${a.slice(0, 6)}…${a.slice(-4)}`
}

// A datetime-local <input> value (YYYY-MM-DDTHH:mm) for a given unix second,
// expressed in the viewer's local timezone.
export function toLocalInput(unixSeconds: number): string {
  const d = new Date(unixSeconds * 1000)
  const local = new Date(d.getTime() - d.getTimezoneOffset() * 60000)
  return local.toISOString().slice(0, 16)
}
