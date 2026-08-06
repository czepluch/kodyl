import { type FormEvent, useEffect, useMemo, useState } from 'react'
import { parseEther } from 'viem'
import { STATE_LABELS, STATUS_LABELS } from './config'
import { useApp } from './ctx'
import { type EventView } from './useKodyl'
import { type RosterEntry, getRoster } from './logs'
import { encodeMetadata, useMetadata } from './metadata'
import { to } from './router'
import { fmtDuration, fmtEth, fmtTime, shortAddr, toLocalInput } from './format'
import { CheckInBanner, EventActions, EventCard, JumpButton, OperatorsPanel, StateBadge, isOrganizer, nextPhaseTs, payoutSwept } from './components'

const DAY = 86400
const MIN_START_AHEAD = 3 * 3600

// --- Discover: open events anyone can join ---

export function Discover() {
  const { events, loading, error } = useApp()
  const open = events.filter((e) => e.state === 0 && !e.cancelled)
  return (
    <>
      <div className="page-head">
        <h2>Upcoming events</h2>
        <a className="ghost-link" href={to('/organize')}>Organizing? Create an event &rarr;</a>
      </div>
      {loading && events.length === 0 ? (
        <p className="muted">Loading&hellip;</p>
      ) : open.length === 0 ? (
        <p className="muted">
          {error ? '' : 'No open events right now. '}
          <a href={to('/organize')}>Create one</a> or run scripts/seed-anvil.sh.
        </p>
      ) : (
        <div className="events">
          {[...open].reverse().map((ev) => (
            <EventCard key={ev.id.toString()} ev={ev} />
          ))}
        </div>
      )}
    </>
  )
}

// --- Event page: full detail + roster from logs ---

const ROSTER_ORDER = ['Registered', 'Checked in', 'Claimed', 'Refunded', 'Cancelled']

export function EventPage({ id }: { id: bigint }) {
  const { events, session, now } = useApp()
  const ev = events.find((e) => e.id === id)
  const meta = useMetadata(ev?.metadataURI ?? '')
  const [roster, setRoster] = useState<RosterEntry[] | null>(null)

  useEffect(() => {
    let live = true
    getRoster(id).then((r) => live && setRoster(r)).catch(() => live && setRoster([]))
    return () => {
      live = false
    }
  }, [id, now])

  const grouped = useMemo(() => {
    const g: Record<string, RosterEntry[]> = {}
    for (const r of roster ?? []) (g[r.status] ??= []).push(r)
    return g
  }, [roster])

  if (!ev) return <div className="detail"><a className="back" href={to('/')}>&larr; All events</a><p className="muted">Loading event #{id.toString()}&hellip;</p></div>

  return (
    <div className="detail">
      <a className="back" href={to('/')}>&larr; All events</a>
      <CheckInBanner ev={ev} />
      <div className="card-head">
        <h2>#{ev.id.toString()} &middot; {meta ? meta.name : '…'}</h2>
        <div className="head-right">
          <StateBadge state={ev.state} cancelled={ev.cancelled} />
          <JumpButton ev={ev} />
        </div>
      </div>
      {meta?.description && <p className="desc">{meta.description}</p>}
      {meta?.location && <p className="loc">{meta.location}</p>}
      {ev.state < 3 && !ev.cancelled && (
        <p className="countdown">
          &rarr; {STATE_LABELS[ev.state + 1] ?? 'Settled'} in {fmtDuration(Number(nextPhaseTs(ev)) - now)}
        </p>
      )}
      {ev.state === 2 && ev.myStatus === 3 && (
        <>
          <p className="countdown">
            Your payout ({fmtEth(ev.deposit + ev.reward)}) unlocks in {fmtDuration(Number(nextPhaseTs(ev)) - now)}.
          </p>
          <p className="countdown">
            Claims open at settlement: the organizer can still approve late check-ins during the dispute period.
          </p>
        </>
      )}

      <div className="grid wide">
        <div><span>Organizer</span><b title={ev.organizer}>{shortAddr(ev.organizer)}{isOrganizer(ev, session.address) ? ' (you)' : ''}</b></div>
        <div><span>Deposit</span><b>{fmtEth(ev.deposit)}</b></div>
        <div><span>Registered</span><b>{ev.registeredCount.toString()}{ev.maxAttendees > 0n ? ` / ${ev.maxAttendees}` : ''}</b></div>
        <div><span>Checked in</span><b>{ev.checkedInCount.toString()}</b></div>
        <div><span>Claimed</span><b>{ev.claimedCount.toString()}</b></div>
        {/* The reward is a moving projection until Settled: one late check-in
            during Dispute can change it several-fold. */}
        <div><span>Reward / attendee</span><b>{fmtEth(ev.reward)}{ev.state < 3 ? ' (projected)' : ''}</b></div>
        <div><span>Starts</span><b>{fmtTime(ev.eventStart)}</b></div>
        <div><span>Ends</span><b>{fmtTime(ev.eventEnd)}</b></div>
        <div><span>Cancel by</span><b>{fmtTime(ev.cancellationDeadline)}</b></div>
        <div><span>Your status</span><b>{STATUS_LABELS[ev.myStatus] ?? '?'}</b></div>
      </div>

      <EventActions ev={ev} roster={roster} />

      {/* Any state: operators can be appointed before or during the event. */}
      {isOrganizer(ev, session.address) && <OperatorsPanel ev={ev} />}

      <h3 className="roster-h">Attendees <span className="muted">(from event logs)</span></h3>
      {roster === null ? (
        <p className="muted">Loading roster&hellip;</p>
      ) : roster.length === 0 ? (
        <p className="muted">Nobody has registered yet.</p>
      ) : (
        <div className="roster">
          {ROSTER_ORDER.filter((s) => grouped[s]?.length).map((status) => (
            <div key={status} className="roster-group">
              <h4>{status} <span className="count">{grouped[status].length}</span></h4>
              <ul>
                {grouped[status]
                  .sort((a, b) => a.ts - b.ts)
                  .map((r) => (
                    <li key={r.address}>
                      <code title={r.address}>{shortAddr(r.address)}</code>
                      {r.address.toLowerCase() === session.address.toLowerCase() && <em> (you)</em>}
                      <time>{r.ts ? fmtTime(r.ts) : ''}</time>
                    </li>
                  ))}
              </ul>
            </div>
          ))}
        </div>
      )}
    </div>
  )
}

// --- My tickets ---

export function MyTickets() {
  const { events, session, loading } = useApp()
  const mine = events.filter((e) => e.myStatus !== 0)
  const upcoming = mine.filter((e) => e.state < 3 && !e.cancelled)
  // A swept payout is no longer claimable - it must not read as "Action needed".
  // Refunds count as action: cancelled events and abandoned ones (settled
  // with zero check-ins) both leave a still-registered attendee owed money.
  const toClaim = mine.filter(
    (e) =>
      (e.state === 3 && e.myStatus === 3 && !payoutSwept(e)) ||
      ((e.cancelled || (e.state === 3 && e.checkedInCount === 0n)) && e.myStatus === 1),
  )
  const past = mine.filter((e) => !upcoming.includes(e) && !toClaim.includes(e))

  if (!session.connected) return <p className="muted">Connect a wallet or pick a demo account to see your tickets.</p>
  if (loading && events.length === 0) return <p className="muted">Loading&hellip;</p>
  if (mine.length === 0) return <p className="muted">You have no registrations yet. <a href={to('/')}>Browse events</a>.</p>

  return (
    <>
      {/* One reminder banner per at-risk event (the component gates itself:
          still Registered, check-in open); hard to miss above the sections. */}
      {upcoming.map((ev) => (
        <CheckInBanner key={ev.id.toString()} ev={ev} showEvent />
      ))}
      <Section title="Action needed" events={toClaim} empty="Nothing to claim." />
      <Section title="Upcoming" events={upcoming} empty="No upcoming events." />
      <Section title="Past" events={past} empty="" />
    </>
  )
}

function Section({ title, events, empty }: { title: string; events: EventView[]; empty: string }) {
  if (events.length === 0 && !empty) return null
  return (
    <div className="section">
      <h2>{title}</h2>
      {events.length === 0 ? (
        <p className="muted">{empty}</p>
      ) : (
        <div className="events">{events.map((ev) => <EventCard key={ev.id.toString()} ev={ev} />)}</div>
      )}
    </div>
  )
}

// --- Organize: create + my events + maintainer panel ---

export function Organize() {
  const { events, session, maintainer, totalHeld } = useApp()
  const mine = events.filter((e) => isOrganizer(e, session.address))
  const amMaintainer = maintainer && maintainer.toLowerCase() === session.address.toLowerCase()

  return (
    <>
      <h2>Create an event</h2>
      <CreateEventForm />

      <div className="section">
        <h2>Events you organize</h2>
        {mine.length === 0 ? (
          <p className="muted">You haven&rsquo;t created any events yet.</p>
        ) : (
          <div className="events">{[...mine].reverse().map((ev) => <EventCard key={ev.id.toString()} ev={ev} />)}</div>
        )}
      </div>

      {amMaintainer && (
        <div className="section maintainer">
          <h2>Maintainer</h2>
          <p className="muted">
            You are the protocol maintainer. Dust from settled events is swept to you. Total held across all events:{' '}
            <b>{fmtEth(totalHeld)}</b>.
          </p>
        </div>
      )}
    </>
  )
}

function CreateEventForm() {
  const { session, now, busy, run } = useApp()
  const [name, setName] = useState('')
  const [description, setDescription] = useState('')
  const [location, setLocation] = useState('')
  const [deposit, setDeposit] = useState('1')
  const [startLocal, setStartLocal] = useState('')
  const [cap, setCap] = useState('0')
  const [err, setErr] = useState<string | null>(null)

  useEffect(() => {
    if (now > 0 && !startLocal) setStartLocal(toLocalInput(now + 30 * DAY))
  }, [now, startLocal])

  function submit(e: FormEvent) {
    e.preventDefault()
    setErr(null)
    if (!session.connected) return setErr('Connect a wallet or pick a demo account first.')
    if (!name.trim()) return setErr('Give the event a name.')
    let args: unknown[]
    try {
      const depWei = parseEther(deposit.trim() as `${number}`)
      if (depWei <= 0n) return setErr('Deposit must be greater than 0.')
      const startMs = new Date(startLocal).getTime()
      if (!Number.isFinite(startMs)) return setErr('Pick a valid start date and time.')
      const start = Math.floor(startMs / 1000)
      if (start < now + MIN_START_AHEAD)
        return setErr(`Start must be at least 3 hours ahead of chain time (currently ${fmtTime(now)}).`)
      const capN = cap.trim() === '' ? 0 : Number(cap)
      if (!Number.isInteger(capN) || capN < 0) return setErr('Capacity must be a whole number (0 = unlimited).')
      const deadline = Math.max(now + 3600, start - 2 * DAY)
      const uri = encodeMetadata({ name: name.trim(), description: description.trim() || undefined, location: location.trim() || undefined })
      args = [depWei, BigInt(deadline), BigInt(start), BigInt(start + DAY), BigInt(DAY), BigInt(capN), uri]
    } catch {
      return setErr('Deposit must be a number, e.g. 0.5.')
    }
    run('Create event', () => session.sendTx('createEvent', args))
  }

  return (
    <form className="create" onSubmit={submit}>
      <div className="fields">
        <label className="wide-field">Name<input value={name} onChange={(e) => setName(e.target.value)} placeholder="Solidity Summit" /></label>
        <label>Deposit (ETH)<input type="number" min="0" step="0.01" value={deposit} onChange={(e) => setDeposit(e.target.value)} /></label>
        <label>Starts<input type="datetime-local" min={now > 0 ? toLocalInput(now + MIN_START_AHEAD) : undefined} value={startLocal} onChange={(e) => setStartLocal(e.target.value)} /></label>
        <label>Capacity (0 = &infin;)<input type="number" min="0" step="1" value={cap} onChange={(e) => setCap(e.target.value)} /></label>
        <label className="wide-field">Location<input value={location} onChange={(e) => setLocation(e.target.value)} placeholder="Berlin / online" /></label>
        <label className="wide-field">Description<input value={description} onChange={(e) => setDescription(e.target.value)} placeholder="What's it about?" /></label>
      </div>
      {err && <p className="field-err">{err}</p>}
      <button type="submit" disabled={busy || now === 0}>Create event</button>
    </form>
  )
}
