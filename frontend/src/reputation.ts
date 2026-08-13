// Organizer track record, derived from the already-loaded event list (the
// app enumerates every event since deployment, so the record is complete).
// The reputation surface of the adversarial-economics work (ECONOMICS.md):
// the capture attacks leave loud counter footprints - a settled event with one claimant
// among many registrants, a zero-check-in settlement - and this makes them
// legible at the moment they matter: before an attendee pays a deposit to a
// stranger. Detection, not prevention: nothing here blocks registration.
import { STATE } from './config'
import type { EventView } from './useKodyl'

export type OrganizerRecord = {
  total: number // events ever created by this organizer, this one included
  settledClean: number // settled, majority checked in - the normal outcome
  singleClaimer: number // settled with exactly 1 check-in among 2+ registrants: the sybil-capture footprint
  lowTurnout: number // settled with fewer than half of registrants checked in (the reward-cap regime)
  abandoned: number // settled with zero check-ins and money still attributed
  cancelled: number
  firstEvent: boolean // the viewed event is this organizer's only one
}

export function organizerRecord(events: EventView[], organizer: string, viewedId: bigint): OrganizerRecord {
  const mine = events.filter((e) => e.organizer.toLowerCase() === organizer.toLowerCase())
  const rec: OrganizerRecord = {
    total: mine.length,
    settledClean: 0,
    singleClaimer: 0,
    lowTurnout: 0,
    abandoned: 0,
    cancelled: 0,
    firstEvent: mine.length === 1 && mine[0]?.id === viewedId,
  }
  for (const e of mine) {
    if (e.cancelled) {
      rec.cancelled++
      continue
    }
    if (e.state !== STATE.Settled) continue
    if (e.checkedInCount === 0n) {
      // Counter caveat: a fully refunded abandonment drains registeredCount
      // and held to zero and then looks like an event nobody ever joined -
      // it fades from the record once every victim is made whole.
      if (e.registeredCount > 0n || e.held > 0n) rec.abandoned++
    } else if (e.checkedInCount === 1n && e.registeredCount > 1n) {
      rec.singleClaimer++
    } else if (e.registeredCount > e.checkedInCount * 2n) {
      rec.lowTurnout++
    } else {
      rec.settledClean++
    }
  }
  return rec
}

export function hasFlags(rec: OrganizerRecord): boolean {
  return rec.singleClaimer > 0 || rec.abandoned > 0 || rec.lowTurnout > 0
}
