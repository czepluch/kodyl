// Log-derived views. The contract can't enumerate an event's attendees
// on-chain (status is a non-enumerable mapping), so the roster and the global
// activity feed are reconstructed from event logs - which is why the ABI
// carries the (hand-authored) events.
//
// Logs live in a module-level incremental store: each sync fetches only
// max(deployBlock, watermark + 1)..latest and appends, so chain history is
// decoded once, not per tick, and eth_getLogs ranges stay small (public
// providers cap them). Block timestamps are cached per block number - one
// getBlock per log-bearing block ever seen. The store resets when the
// deployment address changes (stale deployment.json swap during dev) or when
// the chain got shorter (anvil restart: latest < watermark). Reorg-proofing
// beyond that restart check is deliberately out of scope for a demo.
import { type Log } from 'viem'
import { abi, CONTRACT, publicClient } from './config'
import deployment from './deployment.json'

// Field is absent in stale deployment records - scan from genesis then.
const DEPLOY_BLOCK = BigInt((deployment as { deployBlock?: number }).deployBlock ?? 0)

// The attendee-status-affecting events, and the status each implies.
const ROSTER_EVENTS = ['Registered', 'RegistrationCancelled', 'CheckedIn', 'RefundClaimed', 'Claimed'] as const
const STATUS_OF: Record<string, string> = {
  Registered: 'Registered',
  RegistrationCancelled: 'Cancelled',
  CheckedIn: 'Checked in',
  RefundClaimed: 'Refunded',
  Claimed: 'Claimed',
}

type AnyLog = Log & { eventName?: string; args?: Record<string, unknown> }

type StoredLog = {
  eventName: string
  args: Record<string, unknown>
  blockNumber: bigint
  logIndex: number
  ts: number
}

const store = {
  address: CONTRACT as string,
  synced: -1n, // watermark: fetched through this block; -1n = never
  logs: [] as StoredLog[], // ascending (blockNumber, logIndex)
  seen: new Set<string>(), // txHash:logIndex - belt over the watermark
  blockTs: new Map<string, number>(),
  version: 0, // bumped on append/reset; derived-view caches key off it
}

function reset(): void {
  store.address = CONTRACT
  store.synced = -1n
  store.logs = []
  store.seen = new Set()
  store.blockTs = new Map()
  store.version++
}

function order(a: AnyLog, b: AnyLog): number {
  const bn = (a.blockNumber ?? 0n) - (b.blockNumber ?? 0n)
  if (bn !== 0n) return bn < 0n ? -1 : 1
  return (a.logIndex ?? 0) - (b.logIndex ?? 0)
}

let inflight: Promise<void> | null = null

// Pull the store up to the chain head. Concurrent callers share one in-flight
// fetch (no double-append), and once synced the call reduces to a (viem-cached)
// eth_blockNumber, so consumers can await it freely.
export function ensureSynced(latestHint?: bigint): Promise<void> {
  if (inflight) return inflight
  inflight = sync(latestHint).finally(() => {
    inflight = null
  })
  return inflight
}

async function sync(latestHint?: bigint): Promise<void> {
  if (store.address !== CONTRACT) reset()
  const latest = latestHint ?? (await publicClient.getBlockNumber())
  if (latest < store.synced) reset()
  const from = store.synced < DEPLOY_BLOCK ? DEPLOY_BLOCK : store.synced + 1n
  if (from > latest) return
  const raw = (await publicClient.getContractEvents({
    address: CONTRACT,
    abi,
    fromBlock: from,
    toBlock: latest,
  })) as AnyLog[]
  const fresh = raw.filter((l) => !store.seen.has(`${l.transactionHash}:${l.logIndex}`)).sort(order)
  const missing = [...new Set(fresh.map((l) => (l.blockNumber ?? 0n).toString()))].filter(
    (bn) => !store.blockTs.has(bn),
  )
  await Promise.all(
    missing.map(async (bn) => {
      const block = await publicClient.getBlock({ blockNumber: BigInt(bn) })
      store.blockTs.set(bn, Number(block.timestamp))
    }),
  )
  for (const l of fresh) {
    store.seen.add(`${l.transactionHash}:${l.logIndex}`)
    store.logs.push({
      eventName: l.eventName ?? '',
      args: l.args ?? {},
      blockNumber: l.blockNumber ?? 0n,
      logIndex: l.logIndex ?? 0,
      ts: store.blockTs.get((l.blockNumber ?? 0n).toString()) ?? 0,
    })
  }
  if (fresh.length > 0) store.version++
  store.synced = latest
}

export type RosterEntry = { address: `0x${string}`; status: string; ts: number }

// Result caches return the same array while the store is unchanged, so the
// per-second UI clock re-runs setState with an identical reference (a no-op
// render) instead of re-deriving and re-rendering every tick.
const rosterCache = new Map<string, { version: number; result: RosterEntry[] }>()

// Latest status per attendee for one event, newest action last.
export async function getRoster(eid: bigint): Promise<RosterEntry[]> {
  await ensureSynced()
  const key = eid.toString()
  const hit = rosterCache.get(key)
  if (hit && hit.version === store.version) return hit.result
  const latest = new Map<string, StoredLog>()
  for (const l of store.logs) {
    if (!(ROSTER_EVENTS as readonly string[]).includes(l.eventName)) continue
    if ((l.args.eventId as bigint | undefined) !== eid) continue
    const addr = (l.args.attendee as string | undefined)?.toLowerCase()
    if (addr) latest.set(addr, l)
  }
  const result = [...latest.values()].map((l) => ({
    address: l.args.attendee as `0x${string}`,
    status: STATUS_OF[l.eventName] ?? l.eventName,
    ts: l.ts,
  }))
  rosterCache.set(key, { version: store.version, result })
  return result
}

export type Activity = {
  eventName: string
  eventId?: bigint
  attendee?: `0x${string}`
  amount?: bigint
  ts: number
  key: string
}

const activityCache = { version: -1, limit: 0, result: [] as Activity[] }

// Newest-first feed across all events.
export async function getActivity(limit = 20): Promise<Activity[]> {
  await ensureSynced()
  if (activityCache.version === store.version && activityCache.limit === limit) return activityCache.result
  const result = store.logs
    .slice(-limit)
    .reverse()
    .map((l) => ({
      eventName: l.eventName,
      eventId: l.args.eventId as bigint | undefined,
      attendee: l.args.attendee as `0x${string}` | undefined,
      amount: l.args.amount as bigint | undefined,
      ts: l.ts,
      key: `${l.blockNumber}-${l.logIndex}`,
    }))
  activityCache.version = store.version
  activityCache.limit = limit
  activityCache.result = result
  return result
}
