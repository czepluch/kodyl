// Minimal dependency-free hash router. Routes are simple enough that this beats
// pulling in react-router; swap later if the tree grows.
import { useEffect, useState } from 'react'

export type Route =
  | { name: 'discover' }
  | { name: 'event'; id: bigint }
  | { name: 'me' }
  | { name: 'organize' }

export function parseHash(hash: string): Route {
  const path = hash.replace(/^#/, '') || '/'
  const ev = path.match(/^\/event\/(\d+)/)
  if (ev) return { name: 'event', id: BigInt(ev[1]) }
  if (path.startsWith('/me')) return { name: 'me' }
  if (path.startsWith('/organize')) return { name: 'organize' }
  return { name: 'discover' }
}

export function useRoute(): Route {
  const [hash, setHash] = useState(() => window.location.hash)
  useEffect(() => {
    const on = () => setHash(window.location.hash)
    window.addEventListener('hashchange', on)
    return () => window.removeEventListener('hashchange', on)
  }, [])
  return parseHash(hash)
}

export function to(path: string): string {
  return `#${path}`
}
