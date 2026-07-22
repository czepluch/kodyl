// Shared app context so views/components reach data + the tx runner without
// prop-drilling.
import { createContext, useContext } from 'react'
import type { EventView } from './useKodyl'
import type { Session } from './session'

export type Toast = { kind: 'ok' | 'err' | 'pending'; msg: string }

export type AppCtx = {
  session: Session
  events: EventView[]
  now: number
  totalHeld: bigint
  balance: bigint
  error: string | null
  loading: boolean
  busy: boolean
  refresh: () => Promise<void>
  // Wraps session.sendTx (or any promise) with pending/success/error toasts and
  // a refresh. Components call: run('Register', () => session.sendTx(...)).
  run: (label: string, fn: () => Promise<void>) => Promise<void>
  maintainer: `0x${string}` | null
}

export const Ctx = createContext<AppCtx | null>(null)

export function useApp(): AppCtx {
  const c = useContext(Ctx)
  if (!c) throw new Error('useApp must be used within the app provider')
  return c
}
