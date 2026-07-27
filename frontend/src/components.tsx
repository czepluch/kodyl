import { useState } from 'react'
import { isAddress } from 'viem'
import { ACCOUNTS, STATE_LABELS, STATUS_LABELS, isLocalChain } from './config'
import { useApp } from './ctx'
import { type EventView } from './useKodyl'
import { type RosterEntry } from './logs'
import { warpBy, warpTo } from './actions'
import { useMetadata } from './metadata'
import { type Route, to } from './router'
import { DUST_CLAIM_TIMEOUT, fmtDuration, fmtEth, fmtTime, shortAddr } from './format'

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

// Swept-pot detector - exact ONLY for an unclaimed checked-in viewer
// (myStatus 3) on a Settled event: normal settlement always keeps held large
// enough for every remaining payout, so deposit + reward exceeding held means
// claimDust took the pot after the timeout.
export function payoutSwept(ev: EventView): boolean {
  return ev.state === 3 && ev.myStatus === 3 && ev.deposit + ev.reward > ev.held
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
                {a.label} - {a.role}
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
          {isLocalChain && (
            <button className="ghost sm" onClick={session.useDemo}>Use demo accounts</button>
          )}
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

export function EventActions({ ev, roster }: { ev: EventView; roster?: RosterEntry[] }) {
  const { session, now, busy, run } = useApp()
  const me = session.address
  const organizer = isOrganizer(ev, me)
  const full = ev.maxAttendees > 0n && ev.registeredCount >= ev.maxAttendees
  const canCancel = ev.state === 0 && ev.myStatus === 1 && !ev.cancelled && now <= Number(ev.cancellationDeadline)
  const disabled = busy || !session.connected
  const swept = payoutSwept(ev)
  // claimDust's own precondition, mirrored so the button is enabled exactly
  // when the call cannot revert DustNotClaimable.
  const dustReady =
    ev.claimedCount === ev.checkedInCount || now > Number(ev.eventEnd + ev.disputePeriod) + DUST_CLAIM_TIMEOUT

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
      {ev.state === 3 && ev.myStatus === 3 && !swept && (
        <button disabled={disabled} onClick={() => run('Claim payout', () => session.sendTx('claim', [ev.id]))}>
          Claim payout
        </button>
      )}
      {swept && <span className="muted">Payout was swept to the maintainer after the 30-day timeout.</span>}

      {organizer &&
        (ev.state === 1 || ev.state === 2) &&
        (roster ? (
          <CheckIn ev={ev} roster={roster} />
        ) : (
          // Cards have no roster data - check-in lives on the event page.
          <a className="ghost-link" href={to(`/event/${ev.id}`)}>Check in attendees on the event page &rarr;</a>
        ))}
      {organizer && ev.state === 0 && !ev.cancelled && (
        <button className="ghost" disabled={disabled} onClick={() => run('Cancel event', () => session.sendTx('cancelEvent', [ev.id]))}>
          Cancel event
        </button>
      )}
      {ev.state === 3 && ev.held > 0n && (
        <>
          <button
            className="ghost"
            disabled={disabled || !dustReady}
            onClick={() => run('Sweep dust', () => session.sendTx('claimDust', [ev.id]))}
          >
            Sweep dust &rarr; maintainer
          </button>
          {!dustReady && <span className="muted">held: {fmtEth(ev.held)} awaiting claims</span>}
        </>
      )}
    </div>
  )
}

// Roster-driven check-in (event page only; cards link here). One selection
// goes through checkIn; several go through checkInBatch(uint256,address[]),
// the call the contract dispatches by hand-decoding calldata in its payable
// fallback. The free-text input covers an attendee not yet visible in logs.
// Inline layout styles: styles.css is out of scope for this phase.
function CheckIn({ ev, roster }: { ev: EventView; roster: RosterEntry[] }) {
  const { session, busy, run } = useApp()
  const [selected, setSelected] = useState<Record<string, boolean>>({})
  const [extra, setExtra] = useState('')

  const registered = roster.filter((r) => r.status === 'Registered')
  const picked = registered.filter((r) => selected[r.address.toLowerCase()]).map((r) => r.address)
  const typed = extra.trim()
  const typedOk = typed === '' || isAddress(typed)
  const addrs: `0x${string}`[] = [...picked]
  if (typed && isAddress(typed) && !picked.some((a) => a.toLowerCase() === typed.toLowerCase())) addrs.push(typed)

  function toggle(address: string) {
    const k = address.toLowerCase()
    setSelected((s) => ({ ...s, [k]: !s[k] }))
  }

  function submit() {
    const targets = [...addrs]
    const [label, send] =
      targets.length === 1
        ? (['Check in', () => session.sendTx('checkIn', [ev.id, targets[0]])] as const)
        : ([`Check in ${targets.length} attendees`, () => session.sendTx('checkInBatch', [ev.id, targets])] as const)
    run(label, async () => {
      await send()
      // Only on success: the refreshed roster drops them from Registered, so
      // the selection must not point at vanished checkboxes.
      setSelected({})
      setExtra('')
    })
  }

  return (
    <div style={{ flexBasis: '100%' }}>
      {registered.length > 0 ? (
        <div style={{ display: 'flex', flexWrap: 'wrap', gap: '4px 14px', fontSize: 13 }}>
          {registered.map((r) => (
            <label key={r.address}>
              <input
                type="checkbox"
                checked={!!selected[r.address.toLowerCase()]}
                onChange={() => toggle(r.address)}
              />{' '}
              <code title={r.address}>{shortAddr(r.address)}</code>
            </label>
          ))}
        </div>
      ) : (
        <p className="muted" style={{ fontSize: 13, margin: 0 }}>No registered attendees in the logs yet.</p>
      )}
      <div className="checkin" style={{ marginTop: 8 }}>
        <input placeholder="0x... address not listed yet" value={extra} onChange={(e) => setExtra(e.target.value)} />
        <button disabled={busy || !session.connected || addrs.length === 0 || !typedOk} onClick={submit}>
          Check in{addrs.length > 1 ? ` ${addrs.length}` : ''}
        </button>
      </div>
      <p className="muted" style={{ fontSize: 12, margin: '6px 0 0' }}>
        Selecting several sends one checkInBatch call, dispatched by the contract's hand-decoded fallback.
      </p>
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
  if (!isLocalChain) return null // anvil-only affordances
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
                  <option key={a.address} value={i}>{a.label} - {a.role}</option>
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
  if (!isLocalChain || ev.state >= 3 || ev.cancelled) return null
  return (
    <button className="ghost sm" disabled={busy} onClick={() => run('Advance to next phase', () => warpTo(nextPhaseTs(ev)))}>
      &#9193; Jump to {STATE_LABELS[ev.state + 1] ?? 'Settled'}
    </button>
  )
}
