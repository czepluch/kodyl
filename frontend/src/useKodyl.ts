// Data layer: reads the singleton's per-event state with a viem public client.
// It refreshes on every new block (chain state, including timestamp-derived
// event state, only changes when a block is mined - by a tx or a time warp),
// with a stale-response guard so switching accounts mid-flight can't apply old
// data, and caches each event's immutable parameters so only the mutable
// fields are re-read.
import { useCallback, useEffect, useRef, useState } from 'react'
import { abi, CONTRACT, publicClient } from './config'
import { ensureSynced } from './logs'

export type EventView = {
  id: bigint
  organizer: `0x${string}`
  deposit: bigint
  cancellationDeadline: bigint
  eventStart: bigint
  eventEnd: bigint
  disputePeriod: bigint
  maxAttendees: bigint
  metadataURI: string
  cancelled: boolean
  state: number
  registeredCount: bigint
  checkedInCount: bigint
  claimedCount: bigint
  held: bigint
  reward: bigint
  rebate: bigint
  myStatus: number
}

// getEvent's 7-tuple is immutable after creation - cache it per id.
type Params = Pick<
  EventView,
  'organizer' | 'deposit' | 'cancellationDeadline' | 'eventStart' | 'eventEnd' | 'disputePeriod' | 'maxAttendees'
>

async function read<T>(functionName: string, args: unknown[]): Promise<T> {
  return publicClient.readContract({ address: CONTRACT, abi, functionName, args }) as Promise<T>
}

async function loadEvent(id: bigint, me: `0x${string}`, cache: Map<string, Params>): Promise<EventView> {
  let params = cache.get(id.toString())
  if (!params) {
    const ev = await read<readonly [`0x${string}`, bigint, bigint, bigint, bigint, bigint, bigint]>('getEvent', [id])
    params = {
      organizer: ev[0],
      deposit: ev[1],
      cancellationDeadline: ev[2],
      eventStart: ev[3],
      eventEnd: ev[4],
      disputePeriod: ev[5],
      maxAttendees: ev[6],
    }
    cache.set(id.toString(), params)
  }
  const [meta, cancelled, state, reg, chk, clm, held, reward, rebate, myStatus] = await Promise.all([
    read<string>('metadataURI', [id]),
    read<boolean>('cancelled', [id]),
    read<bigint>('getState', [id]),
    read<bigint>('registeredCount', [id]),
    read<bigint>('checkedInCount', [id]),
    read<bigint>('claimedCount', [id]),
    read<bigint>('held', [id]),
    read<bigint>('rewardPerAttendee', [id]),
    read<bigint>('noShowRebate', [id]),
    read<bigint>('attendees', [id, me]),
  ])
  return {
    id,
    ...params,
    metadataURI: meta,
    cancelled,
    state: Number(state),
    registeredCount: reg,
    checkedInCount: chk,
    claimedCount: clm,
    held,
    reward,
    rebate,
    myStatus: Number(myStatus),
  }
}

export function useKodyl(me: `0x${string}`) {
  const [events, setEvents] = useState<EventView[]>([])
  const [totalHeld, setTotalHeld] = useState<bigint>(0n)
  const [balance, setBalance] = useState<bigint>(0n)
  const [maintainer, setMaintainer] = useState<`0x${string}` | null>(null)
  const [now, setNow] = useState<number>(0)
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)
  const cache = useRef<Map<string, Params>>(new Map())
  const seq = useRef(0)
  // Last observed block timestamp and the wall clock at which we saw it.
  const anchor = useRef({ ts: 0, at: 0 })

  const refresh = useCallback(async () => {
    const my = ++seq.current
    try {
      const [count, held, maint, bal, block] = await Promise.all([
        read<bigint>('eventCount', []),
        read<bigint>('totalHeld', []),
        read<`0x${string}`>('maintainer', []),
        publicClient.getBalance({ address: me }),
        publicClient.getBlock(),
      ])
      const ids = Array.from({ length: Number(count) }, (_, i) => BigInt(i + 1))
      const loaded = await Promise.all(ids.map((id) => loadEvent(id, me, cache.current)))
      if (my !== seq.current) return // a newer refresh started; drop this one
      setEvents(loaded)
      setTotalHeld(held)
      setMaintainer(maint)
      setBalance(bal)
      anchor.current = { ts: Number(block.timestamp), at: Date.now() }
      setNow(anchor.current.ts)
      setError(null)
    } catch (e) {
      if (my === seq.current) setError(e instanceof Error ? e.message : 'read failed')
      console.error('refresh failed', e)
    } finally {
      if (my === seq.current) setLoading(false)
    }
  }, [me])

  useEffect(() => {
    ensureSynced().catch(() => {})
    refresh()
    // Every state change requires a mined block, so watching blocks catches
    // txs and time warps without a wasteful fixed poll. The block drives the
    // log store too; passing block.number spares it an eth_blockNumber.
    const unwatch = publicClient.watchBlocks({
      emitOnBegin: false,
      onBlock: (block) => {
        ensureSynced(block.number).catch(() => {})
        refresh()
      },
    })
    return () => unwatch()
  }, [refresh])

  // The displayed clock ticks on wall time between blocks (so countdowns move
  // on anvil without mining) and re-anchors to the block timestamp on every
  // refresh. Contract state stays strictly block-derived: getState and every
  // other field come from on-chain reads, never from this clock.
  useEffect(() => {
    const t = setInterval(() => {
      const { ts, at } = anchor.current
      if (ts > 0) setNow(ts + Math.floor((Date.now() - at) / 1000))
    }, 1000)
    return () => clearInterval(t)
  }, [])

  return { events, totalHeld, balance, maintainer, now, loading, error, refresh }
}
