import { useEffect, useState } from 'react'
import { type Hex, isAddress, recoverTypedDataAddress } from 'viem'
import { ACCOUNTS, CONTRACT, STATE_LABELS, STATUS_LABELS, chain, isLocalChain } from './config'
import { useApp } from './ctx'
import { type EventView } from './useKodyl'
import { type RosterEntry, getOperators } from './logs'
import { warpBy, warpTo } from './actions'
import { useMetadata } from './metadata'
import { type Route, to } from './router'
import { DOMAIN, PRESENCE_TYPES, TICKET_TYPES } from './eip712'
import { type TicketVoucher, type Voucher, addToOutbox, loadTicket, outboxFor, removeFromOutbox, saveTicket } from './outbox'
import { fetchVoucher, postVoucher } from './mailbox'
import { QrCode, QrScanner } from './qr'
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

// Whether `me` is an appointed door operator of this event, from the same
// OperatorSet log store the operators panel lists (version-cached, so an
// unchanged store costs no extra RPC). Skipped for the organizer, whose
// authority is direct; a just-appointed operator sees the door on the next
// log sync.
function useAmOperator(eid: bigint, me: string, organizer: boolean): boolean {
  const { now } = useApp()
  const [am, setAm] = useState(false)
  // Identity or event changed: drop the stale answer synchronously, so the
  // previous viewer's operator status never renders for the next one while
  // the async re-check is in flight.
  useEffect(() => setAm(false), [eid, me])
  useEffect(() => {
    if (organizer) return
    let live = true
    getOperators(eid)
      .then((ops) => live && setAm(ops.some((o) => o.toLowerCase() === me.toLowerCase())))
      // A failed sync is not an answer: keep the last known value, or an
      // operator's whole Door would unmount (losing its local state) on any
      // transient RPC blip.
      .catch(() => {})
    return () => {
      live = false
    }
  }, [eid, me, organizer, now])
  return !organizer && am
}

// roster: undefined on cards (no roster fetched there), null while the event
// page is still loading it, an array once loaded.
export function EventActions({ ev, roster }: { ev: EventView; roster?: RosterEntry[] | null }) {
  const { session, now, busy, run } = useApp()
  const me = session.address
  const organizer = isOrganizer(ev, me)
  // An operator runs the Door only: the roster path (checkIn/checkInBatch) is
  // organizer-only on-chain and would revert NotOrganizer.
  const amOperator = useAmOperator(ev.id, me, organizer)
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
      {(ev.cancelled || (ev.state === 3 && ev.checkedInCount === 0n)) && ev.myStatus === 1 && (
        // Cancelled events and abandoned ones (settled with zero check-ins)
        // share the refund path; both never expire.
        <button disabled={disabled} onClick={() => run('Claim refund', () => session.sendTx('claimRefund', [ev.id]))}>
          Claim refund
        </button>
      )}
      {ev.myStatus === 1 && !ev.cancelled && ev.state < 3 && <TicketButton ev={ev} />}
      {ev.state === 3 && ev.myStatus === 3 && !swept && (
        <button disabled={disabled} onClick={() => run('Claim payout', () => session.sendTx('claim', [ev.id]))}>
          Claim payout
        </button>
      )}
      {swept && <span className="muted">Payout was swept to the maintainer after the 30-day timeout.</span>}

      {(organizer || amOperator) &&
        (ev.state === 1 || ev.state === 2) &&
        (roster === undefined ? (
          // Cards have no roster data - check-in lives on the event page.
          <a className="ghost-link" href={to(`/event/${ev.id}`)}>Check in attendees on the event page &rarr;</a>
        ) : roster === null ? (
          <span className="muted">Loading roster&hellip;</span>
        ) : (
          <CheckIn ev={ev} roster={roster} organizer={organizer} />
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
// An operator gets the Door alone - the roster path is organizer-only
// on-chain, so its tab would only offer a guaranteed revert.
function CheckIn({ ev, roster, organizer }: { ev: EventView; roster: RosterEntry[]; organizer: boolean }) {
  const [tab, setTab] = useState<'roster' | 'door'>(organizer ? 'roster' : 'door')
  // Losing the organizer role without unmounting (identity switch while an
  // operator keeps the area alive) hides the Roster tab; land on the Door so
  // the active tab always exists.
  useEffect(() => {
    if (!organizer) setTab('door')
  }, [organizer])
  return (
    <div style={{ flexBasis: '100%' }}>
      <div className="tabs">
        {organizer && (
          <button className={tab === 'roster' ? 'tab active' : 'tab'} onClick={() => setTab('roster')}>
            Roster
          </button>
        )}
        <button className={tab === 'door' ? 'tab active' : 'tab'} onClick={() => setTab('door')}>
          Door
        </button>
      </div>
      {tab === 'roster' && organizer ? <RosterCheckIn ev={ev} roster={roster} /> : <Door ev={ev} roster={roster} />}
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
  const { session, busy, run } = useApp()
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

    await run('Countersign presence', async () => {
      const presenceSig = (await session.signTypedData(DOMAIN, PRESENCE_TYPES, 'Presence', {
        eventId: ev.id,
        attendee: attendee as `0x${string}`,
      })) as string
      const voucher: Voucher = {
        eventId: ev.id.toString(),
        attendee,
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

  function submitAll() {
    // A proof has no expiry of its own: everything pending submits, valid
    // until the dispute window closes check-in on-chain.
    const items = outboxFor(ev.id)
    if (items.length === 0) return
    const label = items.length === 1 ? 'Submit check-in' : `Submit ${items.length} check-ins`
    run(label, async () => {
      if (items.length === 1) {
        const v = items[0]
        await session.sendTx('checkInWithProof', [
          BigInt(v.eventId),
          v.attendee as `0x${string}`,
          v.ticketSig as Hex,
          v.presenceSig as Hex,
        ])
      } else {
        await session.sendTx('checkInBatchWithProofs', [
          ev.id,
          items.map((v) => v.attendee as `0x${string}`),
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
        on-chain until the dispute window closes check-in.
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
            <button disabled={busy || !session.connected} onClick={submitAll}>
              Submit {pending.length > 1 ? `${pending.length} ` : ''}on-chain
            </button>
          </div>
          <ul>
            {pending.map((v) => (
              <li key={v.attendee}>
                <code title={v.attendee}>{shortAddr(v.attendee)}</code>
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

// Mailbox poll for the caller's own countersigned voucher, shared by every
// banner instance. Coarse timer (not the per-second UI clock); re-polls when
// the identity or event changes; `active: false` skips the network entirely
// (the attendee is not at risk, so there is nothing to look for).
function useMailboxVoucher(eid: bigint, me: string, active: boolean): { voucher: Voucher | null; polled: boolean } {
  const [voucher, setVoucher] = useState<Voucher | null>(null)
  const [polled, setPolled] = useState(false)

  useEffect(() => {
    if (!active) return
    let live = true
    // Reset both before the first poll: a voucher fetched for the previous
    // identity/event must never render (or be submitted) for the next one.
    setVoucher(null)
    setPolled(false)
    const done = () => {
      if (live) setPolled(true)
    }
    const poll = () =>
      fetchVoucher(eid, me)
        .then((v) => {
          if (!live) return
          // The mailbox is untrusted (a hostile one could return a voucher for
          // a different attendee or event). Only ever act on one that is for ME
          // and THIS event; otherwise confirm would submit someone else's
          // check-in on my dime and the banner would never clear (my status
          // stays Registered). The contract still verifies the signatures.
          const mine = v && v.attendee?.toLowerCase() === me.toLowerCase() && v.eventId === eid.toString()
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
  }, [eid, me, active])

  return active ? { voucher, polled } : { voucher: null, polled: false }
}

// Check-in reminder: a full-width banner an at-risk attendee cannot miss,
// shown for a still-Registered, not-cancelled attendee while check-in is
// open (Active/Dispute). The single source of truth for the self-rescue
// affordance (it replaced the old inline note). Two states:
//  - a countersigned proof is waiting in the mailbox -> confirm it on-chain
//    yourself (anyone may submit; the door apparently never did);
//  - no proof and the event has ended (Dispute) -> only the organizer or an
//    operator can attest a missed scan, and only until the dispute window
//    closes - say so with the concrete deadline. During Active with no proof
//    stay quiet: showing the ticket at the door is the normal path.
// After Settled the contract rejects every check-in, so nothing actionable
// renders. `showEvent` adds the event title (for the My tickets aggregate,
// where the banner sits above the cards).
export function CheckInBanner({ ev, showEvent = false }: { ev: EventView; showEvent?: boolean }) {
  const { session, busy, run } = useApp()
  const me = session.address
  const atRisk = session.connected && ev.myStatus === 1 && !ev.cancelled && (ev.state === 1 || ev.state === 2)
  const { voucher, polled } = useMailboxVoucher(ev.id, me, atRisk)

  // Wait for the first poll so the never-scanned guidance cannot flash before
  // a waiting voucher loads.
  if (!atRisk || !polled) return null
  const closes = fmtTime(ev.eventEnd + ev.disputePeriod)
  const title = showEvent && (
    <a href={to(`/event/${ev.id}`)} className="plain">
      <b><EventTitle uri={ev.metadataURI} id={ev.id} /></b>
    </a>
  )

  if (voucher) {
    return (
      <div className="banner" role="alert">
        {title}
        <span>
          Your check-in is not on-chain yet - confirm it. Check-in closes {closes}.
        </span>
        <button
          disabled={busy}
          onClick={() =>
            run('Confirm check-in on-chain', () =>
              session.sendTx('checkInWithProof', [
                BigInt(voucher.eventId),
                voucher.attendee as `0x${string}`,
                voucher.ticketSig as Hex,
                voucher.presenceSig as Hex,
              ]),
            )
          }
        >
          Confirm check-in on-chain
        </button>
      </div>
    )
  }

  if (ev.state !== 2) return null
  return (
    <div className="banner" role="alert">
      {title}
      <span>
        Not checked in? If you attended but were not scanned, contact the organizer before {closes} - after that,
        check-in for this event closes.
      </span>
    </div>
  )
}

// --- door operators (organizer's event page, any state) ---

// List / appoint / revoke the event's door operators. The current set is
// reconstructed from OperatorSet logs (getOperators): isOperator is a point
// query and the contract has no enumeration. Appointing an operator shares
// the organizer's full check-in authority (spec.md trust surface), so the
// copy says exactly that.
export function OperatorsPanel({ ev }: { ev: EventView }) {
  const { session, now, busy, run } = useApp()
  const [operators, setOperators] = useState<`0x${string}`[] | null>(null)
  const [addr, setAddr] = useState('')

  // Keyed on the ticking clock like the event page's roster effect:
  // getOperators is cached by the log store version, so an unchanged store
  // returns the same reference and the setState is a no-op render. A mined
  // setOperator bumps the store on the next block and the list refreshes.
  useEffect(() => {
    let live = true
    getOperators(ev.id).then((o) => live && setOperators(o)).catch(() => live && setOperators([]))
    return () => {
      live = false
    }
  }, [ev.id, now])

  const typed = addr.trim()
  const disabled = busy || !session.connected

  return (
    <div className="operators">
      <h3 className="roster-h">Door operators <span className="muted">(from event logs)</span></h3>
      <p className="muted" style={{ fontSize: 12, margin: '0 0 8px' }}>
        An operator&rsquo;s Presence signature checks attendees in with your full authority - appoint accordingly.
        Removal takes effect immediately; their earlier submitted check-ins stand.
      </p>
      {operators === null ? (
        <p className="muted" style={{ fontSize: 13 }}>Loading operators&hellip;</p>
      ) : operators.length === 0 ? (
        <p className="muted" style={{ fontSize: 13, margin: '0 0 8px' }}>No operators appointed.</p>
      ) : (
        <div className="door-pending" style={{ marginTop: 0, marginBottom: 8 }}>
          <ul>
            {operators.map((o) => (
              <li key={o}>
                <code title={o}>{shortAddr(o)}</code>
                <button
                  className="ghost sm"
                  disabled={disabled}
                  onClick={() => run('Remove operator', () => session.sendTx('setOperator', [ev.id, o, false]))}
                >
                  remove
                </button>
              </li>
            ))}
          </ul>
        </div>
      )}
      <div className="checkin">
        <input placeholder="0x... operator address" value={addr} onChange={(e) => setAddr(e.target.value)} />
        <button
          disabled={disabled || !isAddress(typed)}
          onClick={() =>
            run('Add operator', async () => {
              await session.sendTx('setOperator', [ev.id, typed, true])
              setAddr('')
            })
          }
        >
          Add operator
        </button>
      </div>
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
      Jump to {STATE_LABELS[ev.state + 1] ?? 'Settled'} &raquo;
    </button>
  )
}
