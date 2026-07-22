// Log-derived views. The contract can't enumerate an event's attendees
// on-chain (status is a non-enumerable mapping), so the roster and the global
// activity feed are reconstructed from event logs - which is why the ABI
// carries the (hand-authored) events.
import { type Log } from 'viem'
import { abi, CONTRACT, publicClient } from './config'

// The attendee-status-affecting events, and the status each implies.
const ROSTER_EVENTS = ['Registered', 'RegistrationCancelled', 'CheckedIn', 'RefundClaimed', 'Claimed'] as const
const STATUS_OF: Record<string, string> = {
  Registered: 'Registered',
  RegistrationCancelled: 'Cancelled',
  CheckedIn: 'Checked in',
  RefundClaimed: 'Refunded',
  Claimed: 'Claimed',
}

export type RosterEntry = { address: `0x${string}`; status: string; ts: number }

type AnyLog = Log & { eventName?: string; args?: Record<string, unknown> }

function order(a: AnyLog, b: AnyLog): number {
  const bn = (a.blockNumber ?? 0n) - (b.blockNumber ?? 0n)
  if (bn !== 0n) return bn < 0n ? -1 : 1
  return (a.logIndex ?? 0) - (b.logIndex ?? 0)
}

async function timestampsFor(blockNumbers: bigint[]): Promise<Map<string, number>> {
  const uniq = [...new Set(blockNumbers.map((b) => b.toString()))]
  const out = new Map<string, number>()
  await Promise.all(
    uniq.map(async (bnStr) => {
      const block = await publicClient.getBlock({ blockNumber: BigInt(bnStr) })
      out.set(bnStr, Number(block.timestamp))
    }),
  )
  return out
}

// Latest status per attendee for one event, newest action last.
export async function getRoster(eid: bigint): Promise<RosterEntry[]> {
  const groups = await Promise.all(
    ROSTER_EVENTS.map((eventName) =>
      publicClient.getContractEvents({ address: CONTRACT, abi, eventName, args: { eventId: eid }, fromBlock: 0n }),
    ),
  )
  const logs = (groups.flat() as AnyLog[]).sort(order)
  const latest = new Map<string, AnyLog>()
  for (const l of logs) {
    const addr = (l.args?.attendee as string)?.toLowerCase()
    if (addr) latest.set(addr, l)
  }
  const ts = await timestampsFor([...latest.values()].map((l) => l.blockNumber ?? 0n))
  return [...latest.values()].map((l) => ({
    address: l.args!.attendee as `0x${string}`,
    status: STATUS_OF[l.eventName!] ?? l.eventName!,
    ts: ts.get((l.blockNumber ?? 0n).toString()) ?? 0,
  }))
}

export type Activity = {
  eventName: string
  eventId?: bigint
  attendee?: `0x${string}`
  amount?: bigint
  ts: number
  key: string
}

// Newest-first feed across all events.
export async function getActivity(limit = 20): Promise<Activity[]> {
  const logs = ((await publicClient.getContractEvents({ address: CONTRACT, abi, fromBlock: 0n })) as AnyLog[])
    .sort(order)
    .reverse()
    .slice(0, limit)
  const ts = await timestampsFor(logs.map((l) => l.blockNumber ?? 0n))
  return logs.map((l) => ({
    eventName: l.eventName!,
    eventId: l.args?.eventId as bigint | undefined,
    attendee: l.args?.attendee as `0x${string}` | undefined,
    amount: l.args?.amount as bigint | undefined,
    ts: ts.get((l.blockNumber ?? 0n).toString()) ?? 0,
    key: `${l.blockNumber}-${l.logIndex}`,
  }))
}
