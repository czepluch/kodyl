import { useEffect, useMemo, useState } from 'react'
import { Ctx, type Toast } from './ctx'
import { useSession } from './session'
import { useKodyl } from './useKodyl'
import { useRoute, to } from './router'
import { decodeError } from './actions'
import { type Activity, getActivity } from './logs'
import { fmtEth, fmtTime, shortAddr } from './format'
import { DemoDrawer, IdentityBar, Nav } from './components'
import { Discover, EventPage, MyTickets, Organize } from './views'

export default function App() {
  const session = useSession()
  const data = useKodyl(session.address)
  const route = useRoute()
  const [busy, setBusy] = useState(false)
  const [toast, setToast] = useState<Toast | null>(null)

  useEffect(() => {
    if (!toast || toast.kind === 'pending') return
    const t = setTimeout(() => setToast(null), 4500)
    return () => clearTimeout(t)
  }, [toast])

  const run = useMemo(
    () => async (label: string, fn: () => Promise<void>) => {
      setBusy(true)
      setToast({ kind: 'pending', msg: `${label}…` })
      try {
        await fn()
        await data.refresh()
        setToast({ kind: 'ok', msg: `${label} ✓` })
      } catch (e) {
        setToast({ kind: 'err', msg: `${label}: ${decodeError(e)}` })
      } finally {
        setBusy(false)
      }
    },
    [data],
  )

  const ctx = useMemo(
    () => ({ session, ...data, busy, run }),
    [session, data, busy, run],
  )

  return (
    <Ctx.Provider value={ctx}>
      <div className="wrap">
        <header>
          <div className="brand">
            <h1><a href={to('/')} className="plain">Kodyl</a></h1>
            <Nav route={route} />
          </div>
          <IdentityBar />
        </header>

        {toast && <div className={`toast ${toast.kind}`}>{toast.msg}</div>}
        {data.error && (
          <div className="toast err">
            Can&rsquo;t reach the chain: is anvil running and the contract deployed? ({data.error})
          </div>
        )}

        <main>
          {route.name === 'discover' && <Discover />}
          {route.name === 'event' && <EventPage id={route.id} />}
          {route.name === 'me' && <MyTickets />}
          {route.name === 'organize' && <Organize />}
        </main>

        {route.name !== 'event' && <ActivityFeed now={data.now} />}

        <footer>
          <p>
            A Core Solidity contract on local anvil. Event state and attendee status cross the ABI as uint256
            ordinals; the attendee roster and this feed are reconstructed from event logs.
          </p>
        </footer>
      </div>
      <DemoDrawer />
    </Ctx.Provider>
  )
}

function ActivityFeed({ now }: { now: number }) {
  const [items, setItems] = useState<Activity[]>([])
  useEffect(() => {
    let live = true
    getActivity(15).then((a) => live && setItems(a)).catch(() => {})
    return () => {
      live = false
    }
  }, [now])

  if (items.length === 0) return null
  return (
    <section className="feed">
      <h2>Recent activity</h2>
      <ul>
        {items.map((a) => (
          <li key={a.key}>
            <span className="feed-ev">{a.eventName}</span>
            {a.eventId !== undefined && (
              <> &middot; <a href={to(`/event/${a.eventId}`)}>#{a.eventId.toString()}</a></>
            )}
            {a.attendee && <> &middot; <code title={a.attendee}>{shortAddr(a.attendee)}</code></>}
            {a.amount !== undefined && a.amount > 0n && <> &middot; {fmtEth(a.amount)}</>}
            <time>{a.ts ? fmtTime(a.ts) : ''}</time>
          </li>
        ))}
      </ul>
    </section>
  )
}
