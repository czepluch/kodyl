// Kodyl voucher mailbox: a dumb, trust-free relay for proof-based check-in.
//
// The door operator countersigns a Presence attestation offline; this service
// carries that half to the attendee (or to a relayer) so anyone can submit the
// Ticket + Presence pair on-chain within the window. It stores and forwards,
// nothing more. It CANNOT check anyone in: the contract verifies both
// signatures, so a garbage voucher only wastes a row. If this service dies,
// the operator's outbox and direct on-chain submission still work.
//
// Zero dependencies: plain node http, run with `node mailbox/server.mjs`
// (PORT env, default 8787). Persistence is an in-memory Map plus a best-effort
// JSON snapshot next to this file - it survives restarts and nothing more.
//
// NOT a spam gate. The production hardening step (reject a voucher unless its
// Presence signature recovers to an on-chain-authorized operator before
// storing) needs a crypto library and is documented in README.md rather than
// added here. See that file for the threat model.

import { createServer } from 'node:http'
import { readFileSync } from 'node:fs'
import { writeFile, rename } from 'node:fs/promises'
import { fileURLToPath } from 'node:url'
import { dirname, join } from 'node:path'

// `|| 8787` (not `?? 8787`): an empty PORT env - trivially set by a shell script
// or systemd EnvironmentFile - is `Number('')` = 0, and listen(0) would bind a
// random ephemeral port. NaN (unset / non-numeric) also falls back.
const PORT = Number(process.env.PORT) || 8787
const HERE = dirname(fileURLToPath(import.meta.url))
const SNAPSHOT = join(HERE, 'vouchers.json')
const MAX_BODY = 1 << 20 // 1 MiB: a voucher is a few hundred bytes; cap abuse.

// The seven voucher fields, all strings on the wire (bigints serialize as
// decimal strings, per the frontend convention).
const FIELDS = ['eventId', 'attendee', 'validUntil', 'ticketSig', 'presenceSig', 'chainId', 'contract']

const isDecimal = (s) => typeof s === 'string' && /^[0-9]+$/.test(s)
const isAddress = (s) => typeof s === 'string' && /^0x[0-9a-fA-F]{40}$/.test(s)
const isSig = (s) => typeof s === 'string' && /^0x[0-9a-fA-F]{130}$/.test(s) // 65 bytes

// Normalize so the key is stable: addresses are case-insensitive on-chain, so
// lowercase them (and the signatures) before keying and storing.
function normalize(body) {
  return {
    eventId: body.eventId,
    attendee: body.attendee.toLowerCase(),
    validUntil: body.validUntil,
    ticketSig: body.ticketSig.toLowerCase(),
    presenceSig: body.presenceSig.toLowerCase(),
    chainId: body.chainId,
    contract: body.contract.toLowerCase(),
  }
}

// One voucher per (chain, contract, event, attendee); a re-scan at the door
// overwrites (last write wins).
const keyOf = (v) => `${v.chainId}:${v.contract}:${v.eventId}:${v.attendee}`

/** @type {Map<string, object>} */
const store = new Map()

// Boot: load the snapshot if present. A corrupt or absent file is not fatal -
// the mailbox simply starts empty.
try {
  const rows = JSON.parse(readFileSync(SNAPSHOT, 'utf8'))
  if (Array.isArray(rows)) {
    for (const v of rows) {
      if (FIELDS.every((f) => typeof v?.[f] === 'string')) store.set(keyOf(v), v)
    }
  }
  console.log(`mailbox: loaded ${store.size} voucher(s) from ${SNAPSHOT}`)
} catch {
  // No snapshot yet, or unreadable: start empty.
}

// Best-effort atomic snapshot: write a temp file then rename over the target,
// so a reader never sees a half-written file. Async so a POST never blocks the
// event loop on disk IO, and coalesced so concurrent POSTs never race on the
// single .tmp path: at most one write is in flight; a POST arriving mid-write
// sets a flag that triggers one trailing write capturing the latest state.
// Failures are swallowed - the in-memory Map is the source of truth.
let snapshotting = false
let snapshotPending = false
async function snapshot() {
  if (snapshotting) {
    snapshotPending = true
    return
  }
  snapshotting = true
  try {
    const tmp = `${SNAPSHOT}.tmp`
    await writeFile(tmp, JSON.stringify([...store.values()]))
    await rename(tmp, SNAPSHOT)
  } catch (err) {
    console.error('mailbox: snapshot failed (continuing):', err.message)
  } finally {
    snapshotting = false
    if (snapshotPending) {
      snapshotPending = false
      snapshot()
    }
  }
}

const CORS = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
  'Access-Control-Allow-Headers': 'Content-Type',
}

function send(res, status, payload) {
  const body = payload === undefined ? '' : JSON.stringify(payload)
  res.writeHead(status, { ...CORS, 'Content-Type': 'application/json' })
  res.end(body)
}

function readBody(req) {
  return new Promise((resolve, reject) => {
    let size = 0
    let tooLarge = false
    const chunks = []
    req.on('data', (c) => {
      size += c.length
      // Past the cap: stop buffering (memory stays bounded to ~MAX_BODY) but
      // keep DRAINING the request. Destroying the socket here would deny the
      // client our 413 response - it would see a TCP reset. Draining lets the
      // upload finish so the client is ready to read the 413 sent on 'end'.
      if (size > MAX_BODY) {
        tooLarge = true
        return
      }
      chunks.push(c)
    })
    req.on('end', () => {
      if (tooLarge) return reject(Object.assign(new Error('payload too large'), { statusCode: 413 }))
      resolve(Buffer.concat(chunks).toString('utf8'))
    })
    req.on('error', reject)
  })
}

async function handlePost(req, res) {
  let body
  try {
    const raw = await readBody(req)
    body = JSON.parse(raw)
  } catch (err) {
    return send(res, err.statusCode ?? 400, { error: err.statusCode === 413 ? 'payload too large' : 'invalid JSON' })
  }
  if (typeof body !== 'object' || body === null) return send(res, 400, { error: 'body must be a JSON object' })

  const missing = FIELDS.filter((f) => typeof body[f] !== 'string' || body[f] === '')
  if (missing.length) return send(res, 400, { error: `missing or non-string fields: ${missing.join(', ')}` })

  if (!isDecimal(body.eventId)) return send(res, 400, { error: 'eventId must be a decimal string' })
  if (!isDecimal(body.validUntil)) return send(res, 400, { error: 'validUntil must be a decimal string' })
  if (!isDecimal(body.chainId)) return send(res, 400, { error: 'chainId must be a decimal string' })
  if (!isAddress(body.attendee)) return send(res, 400, { error: 'attendee must be a 20-byte hex address' })
  if (!isAddress(body.contract)) return send(res, 400, { error: 'contract must be a 20-byte hex address' })
  if (!isSig(body.ticketSig)) return send(res, 400, { error: 'ticketSig must be a 65-byte hex string' })
  if (!isSig(body.presenceSig)) return send(res, 400, { error: 'presenceSig must be a 65-byte hex string' })

  const voucher = normalize(body)
  store.set(keyOf(voucher), voucher)
  snapshot()
  return send(res, 200, { ok: true, key: keyOf(voucher) })
}

function handleGet(res, params) {
  const eventId = params.get('eventId')
  if (!eventId) return send(res, 400, { error: 'eventId query parameter is required' })

  const attendee = params.get('attendee')?.toLowerCase()
  // chainId/contract narrow the match when the caller knows them (the store
  // key includes both); the frontend runs against one deployment, so a plain
  // eventId+attendee query is unambiguous there and these stay optional.
  const chainId = params.get('chainId') ?? undefined
  const contract = params.get('contract')?.toLowerCase() ?? undefined

  const matches = (v) =>
    v.eventId === eventId &&
    (attendee === undefined || v.attendee === attendee) &&
    (chainId === undefined || v.chainId === chainId) &&
    (contract === undefined || v.contract === contract)

  if (attendee) {
    // Single-voucher lookup (self-rescue poll): the voucher or 404.
    for (const v of store.values()) if (matches(v)) return send(res, 200, v)
    return send(res, 404, { error: 'no voucher for that event and attendee' })
  }
  // Drain view (relayer / door): every voucher for the event.
  return send(res, 200, [...store.values()].filter(matches))
}

async function route(req, res, url) {
  if (req.method === 'OPTIONS') {
    res.writeHead(204, CORS)
    return res.end()
  }
  if (url.pathname === '/health' && req.method === 'GET') return send(res, 200, { ok: true, vouchers: store.size })
  if (url.pathname === '/vouchers') {
    if (req.method === 'POST') return handlePost(req, res)
    if (req.method === 'GET') return handleGet(res, url.searchParams)
    return send(res, 405, { error: 'method not allowed' })
  }
  return send(res, 404, { error: 'not found' })
}

const server = createServer((req, res) => {
  // Parse against a FIXED base, never the Host header: `new URL` throws on a
  // malformed authority, and a thrown error out of this callback would crash
  // the whole process. We only need pathname and query from req.url, so the
  // base is a constant.
  let url
  try {
    url = new URL(req.url, 'http://localhost')
  } catch {
    return send(res, 400, { error: 'bad request target' })
  }
  route(req, res, url).catch((err) => {
    console.error('mailbox: request failed:', err?.message)
    if (!res.headersSent) {
      try {
        send(res, 500, { error: 'internal error' })
      } catch {
        // Response already torn down; nothing more to do.
      }
    }
  })
})

// Last-resort guards: a trust-free relay's job is to stay up, so one bad
// request must never take the process down. The known throw sites are handled
// above; these only catch the unforeseen.
process.on('uncaughtException', (err) => console.error('mailbox: uncaught exception (continuing):', err?.message))
process.on('unhandledRejection', (err) => console.error('mailbox: unhandled rejection (continuing):', err))

server.listen(PORT, () => {
  console.log(`mailbox: listening on http://127.0.0.1:${PORT} (snapshot ${SNAPSHOT})`)
})
