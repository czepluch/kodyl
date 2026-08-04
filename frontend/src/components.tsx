import { useEffect, useState } from 'react'
import { type Hex, isAddress, recoverTypedDataAddress } from 'viem'
import { ACCOUNTS, CONTRACT, STATE_LABELS, STATUS_LABELS, chain, isLocalChain } from './config'
import { useApp } from './ctx'
import { type EventView } from './useKodyl'
import { type RosterEntry } from './logs'
import { warpBy, warpTo } from './actions'
import { useMetadata } from './metadata'
import { type Route, to } from './router'
import { DOMAIN, PRESENCE_TYPES, TICKET_TYPES } from './eip712'
import { type TicketVoucher, type Voucher, addToOutbox, loadTicket, outboxFor, removeFromOutbox, saveTicket } from './outbox'
import { fetchVoucher, postVoucher } from './mailbox'
import { QrCode, QrScanner } from './qr'
import { DUST_CLAIM_TIMEOUT, fmtDuration, fmtEth, fmtTime, shortAddr } from './format'

const PROOF_WINDOW = 24 * 3600 // seconds; matches the Presence validUntil window

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

// roster: undefined on cards (no roster fetched there), null while the event
// page is still loading it, an array once loaded.
export function EventActions({ ev, roster }: { ev: EventView; roster?: RosterEntry[] | null }) {
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
      {ev.myStatus === 1 && !ev.cancelled && ev.state < 3 && <TicketButton ev={ev} />}
      {ev.myStatus === 1 && !ev.cancelled && (ev.state === 1 || ev.state === 2) && <CheckInHelp ev={ev} />}
      {ev.state === 3 && ev.myStatus === 3 && !swept && (
        <button disabled={disabled} onClick={() => run('Claim payout', () => session.sendTx('claim', [ev.id]))}>
          Claim payout
        </button>
      )}
      {swept && <span className="muted">Payout was swept to the maintainer after the 30-day timeout.</span>}

      {organizer &&
        (ev.state === 1 || ev.state === 2) &&
        (roster === undefined ? (
          // Cards have no roster data - check-in lives on the event page.
          <a className="ghost-link" href={to(`/event/${ev.id}`)}>Check in attendees on the event page &rarr;</a>
        ) : roster === null ? (
          <span className="muted">Loading roster&hellip;</span>
        ) : (
          <CheckIn ev={ev} roster={roster} />
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

// --- clipboard helper ---

function CopyButton({ text, label = 'Copy' }: { text: string; label?: string }) {
  const [done, setDone] = useState(false)
  async function copy() {
    try {
      await navigator.clipboard.writeText(text)
      setDone(true)
      setTimeout(() => setDone(false), 1500)
    } catch {
      // Clipboard blocked (insecure context / permission): the textarea is
      // still selectable by hand.
    }
  }
  return (
    <button type="button" className="ghost sm" onClick={copy}>
      {done ? 'Copied' : label}
    </button>
  )
}

// --- attendee ticket: sign once, show as copyable text + QR ---

// The voucher the door consumes: eventId + attendee + the attendee's Ticket
// signature. Serialized compact for the QR.
function ticketJson(v: TicketVoucher): string {
  return JSON.stringify({ eventId: v.eventId, attendee: v.attendee, ticketSig: v.ticketSig })
}

function TicketButton({ ev }: { ev: EventView }) {
  const { session, busy, run } = useApp()
  const me = session.address
  const [ticket, setTicket] = useState<TicketVoucher | null>(() => loadTicket(ev.id, me))
  const [open, setOpen] = useState(false)

  // Identity or event changed: reload the cached ticket for this pair.
  useEffect(() => {
    setTicket(loadTicket(ev.id, me))
    setOpen(false)
  }, [ev.id, me])

  function show() {
    if (ticket) {
      setOpen((o) => !o)
      return
    }
    // First tap signs the ticket on demand (a pure signature, no tx); run()
    // gives a toast + a harmless refresh.
    run('Show ticket', async () => {
      const sig = (await session.signTypedData(DOMAIN, TICKET_TYPES, 'Ticket', { eventId: ev.id })) as string
      const v: TicketVoucher = { eventId: ev.id.toString(), attendee: me, ticketSig: sig }
      saveTicket(v)
      setTicket(v)
      setOpen(true)
    })
  }

  return (
    <div style={{ flexBasis: '100%' }}>
      <button className="ghost" disabled={busy || !session.connected} onClick={show}>
        {ticket && open ? 'Hide ticket' : 'Show ticket'}
      </button>
      {!ticket && (
        <p className="muted" style={{ fontSize: 12, margin: '4px 0 0' }}>
          Your wallet signs once to prove this ticket is yours - no gas.
        </p>
      )}
      {open && ticket && (
        <div className="voucher">
          <QrCode text={ticketJson(ticket)} />
          <div className="voucher-side">
            <p className="muted" style={{ margin: '0 0 6px' }}>
              Show this at the door, or copy the text to send it.
            </p>
            <textarea
              className="voucher-text"
              readOnly
              value={ticketJson(ticket)}
              onFocus={(e) => e.currentTarget.select()}
            />
            <CopyButton text={ticketJson(ticket)} label="Copy ticket" />
          </div>
        </div>
      )}
    </div>
  )
}

// Check-in area on the event page: the roster path (organizer transaction) and
// the proof-based Door path (sign a Presence, submit anyone's pair) as tabs.
function CheckIn({ ev, roster }: { ev: EventView; roster: RosterEntry[] }) {
  const [tab, setTab] = useState<'roster' | 'door'>('roster')
  return (
    <div style={{ flexBasis: '100%' }}>
      <div className="tabs">
        <button className={tab === 'roster' ? 'tab active' : 'tab'} onClick={() => setTab('roster')}>
          Roster
        </button>
        <button className={tab === 'door' ? 'tab active' : 'tab'} onClick={() => setTab('door')}>
          Door
        </button>
      </div>
      {tab === 'roster' ? <RosterCheckIn ev={ev} roster={roster} /> : <Door ev={ev} roster={roster} />}
    </div>
  )
}

// Roster-driven check-in (event page only; cards link here). One selection
// goes through checkIn; several go through checkInBatch(uint256,address[]),
// the call the contract dispatches by hand-decoding calldata in its payable
// fallback. The free-text input covers an attendee not yet visible in logs.
// Inline layout styles: styles.css is out of scope for this phase.
function RosterCheckIn({ ev, roster }: { ev: EventView; roster: RosterEntry[] }) {
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

// Door: verify an attendee's ticket, countersign a Presence, and submit the
// pair on-chain. The organizer (or an operator) signs; anyone can submit,
// which is why the pending pile persists in the outbox until it confirms.
function Door({ ev, roster }: { ev: EventView; roster: RosterEntry[] }) {
  const { session, now, busy, run } = useApp()
  const [text, setText] = useState('')
  const [scanning, setScanning] = useState(false)
  const [note, setNote] = useState<string | null>(null)
  const [pending, setPending] = useState<Voucher[]>(() => outboxFor(ev.id))

  const refreshPending = () => setPending(outboxFor(ev.id))

  // Drop pending entries the roster now shows as checked in: submitted by us,
  // by another operator, or self-rescued by the attendee.
  useEffect(() => {
    const checkedIn = new Set(
      roster.filter((r) => r.status === 'Checked in').map((r) => r.address.toLowerCase()),
    )
    let changed = false
    for (const v of outboxFor(ev.id)) {
      if (checkedIn.has(v.attendee.toLowerCase())) {
        removeFromOutbox(ev.id, v.attendee)
        changed = true
      }
    }
    if (changed) refreshPending()
  }, [roster, ev.id])

  const rosterStatus = (addr: string) =>
    roster.find((r) => r.address.toLowerCase() === addr.toLowerCase())?.status

  async function accept(raw: string) {
    setNote(null)
    if (now === 0) return setNote('Chain time not loaded yet - try again in a moment.')
    let parsed: { eventId?: unknown; attendee?: unknown; ticketSig?: unknown }
    try {
      parsed = JSON.parse(raw.trim())
    } catch {
      return setNote('That is not a valid ticket (expected JSON).')
    }
    const eventId = String(parsed.eventId ?? '')
    const attendee = String(parsed.attendee ?? '')
    const ticketSig = String(parsed.ticketSig ?? '')
    if (eventId !== ev.id.toString()) return setNote(`That ticket is for event #${eventId || '?'}, not this one.`)
    if (!isAddress(attendee) || !/^0x[0-9a-fA-F]{130}$/.test(ticketSig))
      return setNote('The ticket is missing a valid attendee or signature.')

    let signer: string
    try {
      signer = await recoverTypedDataAddress({
        domain: DOMAIN,
        types: TICKET_TYPES,
        primaryType: 'Ticket',
        message: { eventId: ev.id },
        signature: ticketSig as Hex,
      })
    } catch {
      return setNote('The ticket signature could not be verified.')
    }
    if (signer.toLowerCase() !== attendee.toLowerCase())
      return setNote('The ticket signature does not match the claimed attendee.')

    const status = rosterStatus(attendee)
    if (status === 'Checked in') return setNote(`${shortAddr(attendee)} is already checked in.`)
    if (status !== 'Registered') return setNote(`${shortAddr(attendee)} is not a registered attendee.`)

    const validUntil = BigInt(now + PROOF_WINDOW)
    await run('Countersign presence', async () => {
      const presenceSig = (await session.signTypedData(DOMAIN, PRESENCE_TYPES, 'Presence', {
        eventId: ev.id,
        attendee: attendee as `0x${string}`,
        validUntil,
      })) as string
      const voucher: Voucher = {
        eventId: ev.id.toString(),
        attendee,
        validUntil: validUntil.toString(),
        ticketSig,
        presenceSig,
        chainId: chain.id.toString(),
        contract: CONTRACT,
      }
      addToOutbox(voucher)
      refreshPending()
      setText('')
      setNote(`${shortAddr(attendee)} verified - ready to submit on-chain.`)
      postVoucher(voucher).catch(() => {}) // best-effort relay; the outbox is the record
    })
  }

  const isExpired = (v: Voucher) => now > 0 && Number(v.validUntil) < now

  function submitAll() {
    // Exclude expired proofs: the batch is all-or-nothing on-chain (one expired
    // proof reverts every check-in with ProofExpired), so a stale voucher would
    // poison an otherwise-valid batch. Expired entries stay in the pile, flagged,
    // for the operator to remove.
    const items = outboxFor(ev.id).filter((v) => !isExpired(v))
    if (items.length === 0) {
      setNote('All pending proofs have expired - remove them and re-scan.')
      return
    }
    const label = items.length === 1 ? 'Submit check-in' : `Submit ${items.length} check-ins`
    run(label, async () => {
      if (items.length === 1) {
        const v = items[0]
        await session.sendTx('checkInWithProof', [
          BigInt(v.eventId),
          v.attendee as `0x${string}`,
          BigInt(v.validUntil),
          v.ticketSig as Hex,
          v.presenceSig as Hex,
        ])
      } else {
        await session.sendTx('checkInBatchWithProofs', [
          ev.id,
          items.map((v) => v.attendee as `0x${string}`),
          items.map((v) => BigInt(v.validUntil)),
          items.map((v) => v.ticketSig as Hex),
          items.map((v) => v.presenceSig as Hex),
        ])
      }
      // Success: every submitted voucher is now consumed (idempotent on-chain).
      for (const v of items) removeFromOutbox(ev.id, v.attendee)
      refreshPending()
    })
  }

  function drop(attendee: string) {
    removeFromOutbox(ev.id, attendee)
    refreshPending()
  }

  return (
    <div>
      <p className="muted" style={{ fontSize: 13, margin: '0 0 8px' }}>
        Scan or paste an attendee&rsquo;s ticket. You countersign their presence; anyone can then submit the pair
        on-chain within 24 hours.
      </p>
      {scanning ? (
        <QrScanner
          onResult={(t) => {
            setScanning(false)
            accept(t)
          }}
          onCancel={() => setScanning(false)}
        />
      ) : (
        <>
          <div className="checkin">
            <button className="ghost sm" disabled={busy} onClick={() => setScanning(true)}>
              Scan QR
            </button>
          </div>
          <textarea
            className="voucher-text"
            style={{ marginTop: 6 }}
            placeholder={'Paste a ticket: {"eventId":"1","attendee":"0x...","ticketSig":"0x..."}'}
            value={text}
            onChange={(e) => setText(e.target.value)}
          />
          <button
            className="ghost sm"
            disabled={busy || !session.connected || text.trim() === ''}
            onClick={() => accept(text)}
          >
            Verify &amp; countersign
          </button>
        </>
      )}
      {note && (
        <p className="muted" style={{ fontSize: 12, margin: '6px 0 0' }}>
          {note}
        </p>
      )}

      {pending.length > 0 && (
        <div className="door-pending">
          <div className="door-pending-head">
            <span>Ready to submit ({pending.length})</span>
            <button
              disabled={busy || !session.connected || pending.every(isExpired)}
              onClick={submitAll}
            >
              Submit {pending.filter((v) => !isExpired(v)).length > 1 ? `${pending.filter((v) => !isExpired(v)).length} ` : ''}
              on-chain
            </button>
          </div>
          <ul>
            {pending.map((v) => (
              <li key={v.attendee}>
                <code title={v.attendee}>{shortAddr(v.attendee)}</code>
                {isExpired(v) && <span className="tag expired">expired</span>}
                <button className="ghost sm" onClick={() => drop(v.attendee)}>
                  remove
                </button>
              </li>
            ))}
          </ul>
        </div>
      )}
    </div>
  )
}

// Attendee-side check-in help, for a still-Registered attendee during
// Active/Dispute. Two cases:
//  - a countersigned proof is waiting in the mailbox -> confirm it on-chain
//    yourself (self-rescue if the door never submitted it);
//  - no proof, and the event has ended (Dispute) -> if you were there but the
//    door never scanned you, only the organizer can check you in, and only
//    until the dispute window closes. Say so, with the concrete deadline.
function CheckInHelp({ ev }: { ev: EventView }) {
  const { session, now, busy, run } = useApp()
  const me = session.address
  const [voucher, setVoucher] = useState<Voucher | null>(null)
  const [polled, setPolled] = useState(false)

  // Poll the mailbox on a coarse timer (not the per-second UI clock), and
  // re-poll when the identity or event changes.
  useEffect(() => {
    let live = true
    setPolled(false)
    const done = () => {
      if (live) setPolled(true)
    }
    const poll = () =>
      fetchVoucher(ev.id, me)
        .then((v) => {
          if (!live) return
          // The mailbox is untrusted (a hostile one could return a voucher for
          // a different attendee or event). Only ever act on one that is for ME
          // and THIS event; otherwise finalize would submit someone else's
          // check-in on my dime and the button would never clear (my status
          // stays Registered). The contract still verifies the signatures.
          const mine = v && v.attendee?.toLowerCase() === me.toLowerCase() && v.eventId === ev.id.toString()
          setVoucher(mine ? v : null)
          done()
        })
        .catch(done)
    poll()
    const t = setInterval(poll, 10000)
    return () => {
      live = false
      clearInterval(t)
    }
  }, [ev.id, me])

  // A countersigned proof is waiting: finalize it on-chain (anyone may submit).
  if (voucher) {
    const expired = now > 0 && Number(voucher.validUntil) < now
    return (
      <div style={{ flexBasis: '100%' }}>
        <button
          disabled={busy || !session.connected || expired}
          onClick={() =>
            run('Confirm check-in on-chain', () =>
              session.sendTx('checkInWithProof', [
                BigInt(voucher.eventId),
                voucher.attendee as `0x${string}`,
                BigInt(voucher.validUntil),
                voucher.ticketSig as Hex,
                voucher.presenceSig as Hex,
              ]),
            )
          }
        >
          {expired ? 'Door check-in expired - ask to be re-scanned' : 'Confirm check-in on-chain'}
        </button>
        {!expired && (
          <p className="muted" style={{ fontSize: 12, margin: '4px 0 0' }}>
            The door signed you in. Organizers usually submit this shortly after the event ends - use this only if your
            check-in has not appeared yet.
          </p>
        )}
      </div>
    )
  }

  // No proof waiting. Once the event has ended (Dispute), a still-registered
  // attendee who was there but never scanned can only be checked in by the
  // organizer, and only until the dispute window closes. During Active they
  // just show their ticket, so stay quiet then; and wait for the first poll to
  // avoid flashing this before a waiting proof loads.
  if (!polled || ev.state !== 2) return null
  return (
    <p className="muted" style={{ flexBasis: '100%', fontSize: 12, margin: 0 }}>
      You are not checked in yet. If you attended but the door did not scan you, contact the organizer before{' '}
      {fmtTime(ev.eventEnd + ev.disputePeriod)} to be checked in - after that, check-in for this event closes.
    </p>
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
      Jump to {STATE_LABELS[ev.state + 1] ?? 'Settled'} &raquo;
    </button>
  )
}
