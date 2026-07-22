// Event metadata. On-chain the contract stores a single metadataURI string; we
// put structured JSON in a self-contained data: URI. resolveMetadata also
// understands http(s) and ipfs:// so switching to real hosting later is a
// no-UI-change swap. Events created without structured metadata (e.g. the
// seed's "ipfs://...") fall back to showing the raw URI as the title.
import { useEffect, useState } from 'react'

export type EventMeta = {
  name: string
  description?: string
  location?: string
  image?: string
}

const DATA_JSON = 'data:application/json'
const IPFS_GATEWAY = 'https://ipfs.io/ipfs/'

export function encodeMetadata(m: EventMeta): string {
  return `${DATA_JSON},${encodeURIComponent(JSON.stringify(m))}`
}

const cache = new Map<string, EventMeta>()

export async function resolveMetadata(uri: string): Promise<EventMeta> {
  const cached = cache.get(uri)
  if (cached) return cached
  let meta: EventMeta
  try {
    if (uri.startsWith(DATA_JSON)) {
      const body = uri.slice(uri.indexOf(',') + 1)
      const json = uri.includes(';base64,') ? atob(body) : decodeURIComponent(body)
      meta = JSON.parse(json)
    } else if (/^(https?:|ipfs:)/.test(uri)) {
      const url = uri.startsWith('ipfs://') ? IPFS_GATEWAY + uri.slice('ipfs://'.length) : uri
      meta = (await (await fetch(url)).json()) as EventMeta
    } else {
      meta = { name: uri }
    }
  } catch {
    meta = { name: uri }
  }
  if (!meta.name) meta.name = uri || '(untitled event)'
  cache.set(uri, meta)
  return meta
}

export function useMetadata(uri: string): EventMeta | null {
  const [meta, setMeta] = useState<EventMeta | null>(() => cache.get(uri) ?? null)
  useEffect(() => {
    let live = true
    resolveMetadata(uri).then((m) => live && setMeta(m))
    return () => {
      live = false
    }
  }, [uri])
  return meta
}
