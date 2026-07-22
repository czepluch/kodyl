import { useState } from 'react'
import { ACCOUNTS, STATE_LABELS, STATUS_LABELS } from './config'
import { useApp } from './ctx'
import { type EventView } from './useKodyl'
import { warpBy, warpTo } from './actions'
import { useMetadata } from './metadata'
import { type Route, to } from './router'
import { fmtDuration, fmtEth, fmtTime, shortAddr } from './format'

const DAY = 86400

// --- primitives ---

export function StateBadge({ state, cancelled }: { state: number; cancelled: boolean }) {
  const s = cancelled ? 4 : state
  return <span className={`badge s${s}`}>{cancelled ? 'Cancelled' : STATE_LABELS[state] ?? '?'}</span>
}

export function nextPhaseTs(ev: EventView): bigint {
  return ev.state === 0 ? ev.eventStart : ev.state === 1 ? ev.eventEnd + 1n : ev.eventEnd + ev.disputePeriod + 1n
}

export function isOrganizer(ev: EventView, me: string): boolean {
  return me.toLowerCase() === ev.organizer.toLowerCase()
}

// --- navigation ---

export function Nav({ route }: { route: Route }) {
  const items: [string, string, Route['name']][] = [
    ['/', 'Discover', 'discover'],
    ['/me', 'My tickets', 'me'],
    ['/organize', 'Organize', 'organize'],
  ]
  return (
    <nav className="nav">
      {items.map(([path, label, name]) => (
        <a key={path} href={to(path)} className={route.name === name ? 'active' : ''}>
          {label}
        </a>
      ))}
    </nav>
  )
}

// --- identity (demo picker <-> real wallet) ---

export function IdentityBar() {
  const { session, balance } = useApp()
  return (
    <div className="identity">
      {session.mode === 'demo' ? (
        <>
          <select value={session.demoIdx} onChange={(e) => session.setDemoIdx(Number(e.target.value))}>
            {ACCOUNTS.map((a, i) => (
              <option key={a.address} value={i}>
                {a.label} &mdash; {a.role}
              </option>
            ))}
          </select>
          <button className="ghost sm" onClick={() => session.connect().catch((e) => alert(e.message))}>
            Connect wallet
          </button>
        </>
      ) : (
        <>
          <span className="tag">wallet</span>
          <button className="ghost sm" onClick={session.useDemo}>Use demo accounts</button>
        </>
      )}
      <code className="addr" title={session.address}>
        {session.connected ? `${shortAddr(session.address)} · ${fmtEth(balance)}` : 'not connected'}
      </code>
    </div>
  )
}

// --- event title from resolved metadata ---

export function EventTitle({ uri, id }: { uri: string; id: bigint }) {
  const meta = useMetadata(uri)
  return (
    <>
      #{id.toString()} &middot; {meta ? meta.name : '…'}
    </>
  )
}

// --- contextual actions (attendee + organizer) ---

export function EventActions({ ev }: { ev: EventView }) {
  const { session, now, busy, run } = useApp()
  const me = session.address
  const organizer = isOrganizer(ev, me)
  const full = ev.maxAttendees > 0n && ev.registeredCount >= ev.maxAttendees
  const canCancel = ev.state === 0 && ev.myStatus === 1 && !ev.cancelled && now <= Number(ev.cancellationDeadline)
  const disabled = busy || !session.connected

  return (
    <div className="actions">
      {ev.state === 0 && ev.myStatus !== 1 && !full && (
        <button disabled={disabled} onClick={() => run('Register', () => session.sendTx('register', [ev.id], ev.deposit))}>
          Register ({fmtEth(ev.deposit)})
        </button>
      )}
      {canCancel && (
        <button disabled={disabled} onClick={() => run('Cancel registration', () => session.sendTx('cancel', [ev.id]))}>
          Cancel &amp; refund
        </button>
      )}
      {ev.cancelled && ev.myStatus === 1 && (
        <button disabled={disabled} onClick={() => run('Claim refund', () => session.sendTx('claimRefund', [ev.id]))}>
          Claim refund
        </button>
      )}
      {ev.state === 3 && ev.myStatus === 3 && (
        <button disabled={disabled} onClick={() => run('Claim payout', () => session.sendTx('claim', [ev.id]))}>
          Claim payout
        </button>
      )}

      {organizer && (ev.state === 1 || ev.state === 2) && <CheckIn ev={ev} />}
      {organizer && ev.state === 0 && !ev.cancelled && (
        <button className="ghost" disabled={disabled} onClick={() => run('Cancel event', () => session.sendTx('cancelEvent', [ev.id]))}>
          Cancel event
        </button>
      )}
      {ev.state === 3 && ev.held > 0n && (
        <button className="ghost" disabled={disabled} onClick={() => run('Sweep dust', () => session.sendTx('claimDust', [ev.id]))}>
          Sweep dust &rarr; maintainer
        </button>
      )}
    </div>
  )
}

function CheckIn({ ev }: { ev: EventView }) {
  const { session, busy, run } = useApp()
  const [addr, setAddr] = useState('')
  const candidates = ACCOUNTS.filter((a) => a.address.toLowerCase() !== ev.organizer.toLowerCase())
  return (
    <div className="checkin">
      <select value={addr} onChange={(e) => setAddr(e.target.value)}>
        <option value="">check in&hellip;</option>
        {candidates.map((a) => (
          <option key={a.address} value={a.address}>{a.label}</option>
        ))}
      </select>
      <button
        disabled={busy || !addr}
        onClick={() => run('Check in', () => session.sendTx('checkIn', [ev.id, addr as `0x${string}`]))}
      >
        Check in
      </button>
    </div>
  )
}

// --- event card (used in Discover / My tickets / Organize) ---

export function EventCard({ ev }: { ev: EventView }) {
  const { session, now } = useApp()
  const meta = useMetadata(ev.metadataURI)
  const organizer = isOrganizer(ev, session.address)
  const untilNext = ev.state < 3 && !ev.cancelled ? Number(nextPhaseTs(ev)) - now : 0

  return (
    <div className="card">
      <div className="card-head">
        <h3><a href={to(`/event/${ev.id}`)} className="plain"><EventTitle uri={ev.metadataURI} id={ev.id} /></a></h3>
        <StateBadge state={ev.state} cancelled={ev.cancelled} />
      </div>
      {meta?.location && <p className="loc">{meta.location}</p>}
      {ev.state < 3 && !ev.cancelled && (
        <p className="countdown">&rarr; {STATE_LABELS[ev.state + 1] ?? 'Settled'} in {fmtDuration(untilNext)}</p>
      )}
      <div className="grid">
        <div><span>Deposit</span><b>{fmtEth(ev.deposit)}</b></div>
        <div><span>Registered</span><b>{ev.registeredCount.toString()}{ev.maxAttendees > 0n ? ` / ${ev.maxAttendees}` : ''}</b></div>
        <div><span>Starts</span><b>{fmtTime(ev.eventStart)}</b></div>
        <div><span>Your status</span><b>{STATUS_LABELS[ev.myStatus] ?? '?'}{organizer ? ' · organizer' : ''}</b></div>
      </div>
      <EventActions ev={ev} />
      <a className="detail-link" href={to(`/event/${ev.id}`)}>Details &amp; attendees &rarr;</a>
    </div>
  )
}

// --- demo controls drawer (dev-only affordances) ---

export function DemoDrawer() {
  const { session, now, busy, run } = useApp()
  const [open, setOpen] = useState(false)
  return (
    <div className={`drawer ${open ? 'open' : ''}`}>
      <button className="drawer-toggle" onClick={() => setOpen((o) => !o)}>
        {open ? '▸' : '◂'} Demo controls
      </button>
      {open && (
        <div className="drawer-body">
          <p className="muted">Local-anvil affordances - not part of the real UX.</p>
          <div className="drawer-row">
            <label>Chain clock ({now ? fmtTime(now) : '…'})</label>
            <div>
              <button className="ghost sm" disabled={busy} onClick={() => run('+1 hour', () => warpBy(3600))}>+1h</button>
              <button className="ghost sm" disabled={busy} onClick={() => run('+1 day', () => warpBy(DAY))}>+1d</button>
              <button className="ghost sm" disabled={busy} onClick={() => run('+7 days', () => warpBy(7 * DAY))}>+7d</button>
            </div>
          </div>
          {session.mode === 'demo' && (
            <div className="drawer-row">
              <label>Impersonating</label>
              <select value={session.demoIdx} onChange={(e) => session.setDemoIdx(Number(e.target.value))}>
                {ACCOUNTS.map((a, i) => (
                  <option key={a.address} value={i}>{a.label} — {a.role}</option>
                ))}
              </select>
            </div>
          )}
        </div>
      )}
    </div>
  )
}

// jump-to-next-phase helper (used on the event page)
export function JumpButton({ ev }: { ev: EventView }) {
  const { busy, run } = useApp()
  if (ev.state >= 3 || ev.cancelled) return null
  return (
    <button className="ghost sm" disabled={busy} onClick={() => run('Advance to next phase', () => warpTo(nextPhaseTs(ev)))}>
      &#9193; Jump to {STATE_LABELS[ev.state + 1] ?? 'Settled'}
    </button>
  )
}
