// End-to-end check for the proof-based check-in wire format. It signs Ticket
// and Presence with viem using the SAME EIP-712 domain/types as src/eip712.ts
// (drift-guarded against that source), submits against the deployed contract,
// and confirms it accepts a valid pair (relayer-submitted and operator-signed
// batch) and rejects wrong-signer and wrong-domain proofs. If the mailbox is
// reachable it also checks a POST/GET voucher roundtrip.
//
// This is the automated half of the phase-4 verification; the UI click-path in
// README.md is the manual half. It is local-only: it uses anvil's dev keys and
// refuses any chain other than 31337.
//
// Prereqs (see README.md "Run it"): a running anvil with the contract deployed
// (scripts/deploy-anvil.sh) and, optionally, the mailbox (node mailbox/server.mjs).
// Run from frontend/:  node scripts/verify-proof-e2e.mjs
// Env: RPC (default http://localhost:8545), MAILBOX (default http://localhost:8787).
import { readFileSync } from 'node:fs'
import { fileURLToPath } from 'node:url'
import { dirname, join } from 'node:path'
import { createPublicClient, createWalletClient, createTestClient, http, parseEther } from 'viem'
import { privateKeyToAccount } from 'viem/accounts'

const RPC = process.env.RPC ?? 'http://localhost:8545'
const MAILBOX = process.env.MAILBOX ?? 'http://localhost:8787'
const SRC = join(dirname(fileURLToPath(import.meta.url)), '..', 'src')
const abi = JSON.parse(readFileSync(join(SRC, 'kodylAbi.json'), 'utf8'))
const deployment = JSON.parse(readFileSync(join(SRC, 'deployment.json'), 'utf8'))
const CONTRACT = deployment.address
if (deployment.chainId !== 31337) {
  console.error(`refusing to run: deployment.json chainId is ${deployment.chainId}, not local anvil (31337)`)
  process.exit(1)
}
const chain = { id: 31337, name: 'anvil', nativeCurrency: { name: 'Ether', symbol: 'ETH', decimals: 18 }, rpcUrls: { default: { http: [RPC] } } }

// Mirror src/eip712.ts, guarded so a drift in the source fails loudly here.
const DOMAIN = { name: 'Kodyl', version: '1', chainId: 31337, verifyingContract: CONTRACT }
const TICKET_TYPES = { Ticket: [{ name: 'eventId', type: 'uint256' }] }
const PRESENCE_TYPES = {
  Presence: [
    { name: 'eventId', type: 'uint256' },
    { name: 'attendee', type: 'address' },
  ],
}
const src = readFileSync(join(SRC, 'eip712.ts'), 'utf8')
for (const n of [
  "name: 'Kodyl'",
  "version: '1'",
  "Ticket: [{ name: 'eventId', type: 'uint256' }]",
  "{ name: 'attendee', type: 'address' }",
]) {
  if (!src.includes(n)) throw new Error(`eip712.ts drift: source no longer contains ${n}`)
}
// The Presence struct must have exactly the two members above - pin the exact
// membership, not just needles: any extra member (validUntil back, a nonce),
// a removed member, or a reorder is wire drift.
const presenceBlock = src.match(/Presence:\s*\[([^\]]*)\]/s)?.[1] ?? ''
const members = [...presenceBlock.matchAll(/\{[^}]*\}/g)].map((m) => m[0].replace(/\s+/g, ''))
if (
  members.length !== 2 ||
  members[0] !== "{name:'eventId',type:'uint256'}" ||
  members[1] !== "{name:'attendee',type:'address'}"
)
  throw new Error(`eip712.ts drift: Presence members are [${members.join(', ')}], expected exactly [eventId, attendee]`)

// anvil well-known dev keys (local only).
const PK = {
  org: '0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80',
  att1: '0x59c6995e998f97a5a0044966f0945389dc9e86dae88c7a8412f4603b6b78690d',
  att2: '0x5de4111afa1a4b94908f83103eb1f1706367c2e68ca870fc3fb9a804cdab365a',
  relayer: '0x7c852118294e51e653712a81e05800f419141751be58f605c371e15141b007a6',
  operator: '0x47e179ec197488593b187f80a00eb0da91f1b9d0b13f8733639f19c30a34926a',
}
const acct = Object.fromEntries(Object.entries(PK).map(([k, v]) => [k, privateKeyToAccount(v)]))
const pub = createPublicClient({ chain, transport: http(RPC) })
const test = createTestClient({ chain, mode: 'anvil', transport: http(RPC) })
const wallet = (a) => createWalletClient({ account: a, chain, transport: http(RPC) })

let pass = 0
const ok = (c, m) => {
  if (!c) throw new Error(`FAIL: ${m}`)
  console.log(`  ok: ${m}`)
  pass++
}
const mine = async (t) => {
  await test.setNextBlockTimestamp({ timestamp: BigInt(t) })
  await test.mine({ blocks: 1 })
}
async function send(a, fn, args, v) {
  const h = await wallet(a).writeContract({ address: CONTRACT, abi, functionName: fn, args, value: v })
  const r = await pub.waitForTransactionReceipt({ hash: h })
  if (r.status !== 'success') throw new Error(`${fn} reverted`)
  return r
}
async function expectRevert(needle, fn) {
  try {
    await fn()
  } catch (e) {
    const m = (e.shortMessage || e.message || '') + JSON.stringify(e.metaMessages || [])
    ok(m.includes(needle), `reverts ${needle}`)
    return
  }
  throw new Error(`FAIL: expected revert ${needle}, but the call succeeded`)
}
const status = (e, a) => pub.readContract({ address: CONTRACT, abi, functionName: 'attendees', args: [e, a] })
const signTicket = (a, eventId) =>
  wallet(a).signTypedData({ account: a, domain: DOMAIN, types: TICKET_TYPES, primaryType: 'Ticket', message: { eventId } })
const signPresence = (a, eventId, attendee) =>
  wallet(a).signTypedData({ account: a, domain: DOMAIN, types: PRESENCE_TYPES, primaryType: 'Presence', message: { eventId, attendee } })

async function main() {
  const now = Number((await pub.getBlock()).timestamp)
  const start = now + 2 * 86400
  await send(acct.org, 'createEvent', [parseEther('1'), BigInt(now + 86400), BigInt(start), BigInt(start + 86400), 86400n, 0n, 'ipfs://e2e'])
  const eid = await pub.readContract({ address: CONTRACT, abi, functionName: 'eventCount', args: [] })
  ok(eid > 0n, 'event created')
  await send(acct.att1, 'register', [eid], parseEther('1'))
  await send(acct.att2, 'register', [eid], parseEther('1'))
  await mine(start)

  {
    const t = await signTicket(acct.att1, eid)
    const p = await signPresence(acct.org, eid, acct.att1.address)
    await send(acct.relayer, 'checkInWithProof', [eid, acct.att1.address, t, p])
    ok((await status(eid, acct.att1.address)) === 3n, 'checkInWithProof accepted (relayer-submitted)')
  }
  {
    await send(acct.org, 'setOperator', [eid, acct.operator.address, true])
    const t = await signTicket(acct.att2, eid)
    const p = await signPresence(acct.operator, eid, acct.att2.address)
    await send(acct.relayer, 'checkInBatchWithProofs', [eid, [acct.att2.address], [t], [p]])
    ok((await status(eid, acct.att2.address)) === 3n, 'operator-signed batch accepted')
  }
  {
    const t = await signTicket(acct.att2, eid) // att2 signs, claims att1
    const p = await signPresence(acct.org, eid, acct.att1.address)
    await expectRevert('TicketSignerMismatch', () => send(acct.relayer, 'checkInWithProof', [eid, acct.att1.address, t, p]))
  }
  {
    const other = { ...DOMAIN, verifyingContract: '0x000000000000000000000000000000000000dEaD' }
    const t = await wallet(acct.att1).signTypedData({ account: acct.att1, domain: other, types: TICKET_TYPES, primaryType: 'Ticket', message: { eventId: eid } })
    const p = await signPresence(acct.org, eid, acct.att1.address)
    await expectRevert('TicketSignerMismatch', () => send(acct.relayer, 'checkInWithProof', [eid, acct.att1.address, t, p]))
  }
  {
    // A proof has no expiry of its own: past the dispute window the event is
    // Settled and the state gate is what rejects it.
    const now2 = Number((await pub.getBlock()).timestamp)
    const start2 = now2 + 2 * 86400
    await send(acct.org, 'createEvent', [parseEther('1'), BigInt(now2 + 86400), BigInt(start2), BigInt(start2 + 86400), 86400n, 0n, 'ipfs://e2e2'])
    const eid2 = await pub.readContract({ address: CONTRACT, abi, functionName: 'eventCount', args: [] })
    await send(acct.att1, 'register', [eid2], parseEther('1'))
    await mine(start2)
    const t = await signTicket(acct.att1, eid2)
    const p = await signPresence(acct.org, eid2, acct.att1.address)
    await mine(start2 + 2 * 86400 + 1) // past eventEnd + disputePeriod: Settled
    await expectRevert('CheckInWindowClosed', () => send(acct.relayer, 'checkInWithProof', [eid2, acct.att1.address, t, p]))
  }

  // Mailbox roundtrip (skipped if the relay is not running).
  const health = await fetch(`${MAILBOX}/health`).then((r) => r.ok).catch(() => false)
  if (!health) {
    console.log(`  skip: mailbox not reachable at ${MAILBOX} (start it with: node mailbox/server.mjs)`)
  } else {
    const t = await signTicket(acct.att1, eid)
    const p = await signPresence(acct.org, eid, acct.att1.address)
    const voucher = { eventId: eid.toString(), attendee: acct.att1.address, ticketSig: t, presenceSig: p, chainId: '31337', contract: CONTRACT }
    const post = await fetch(`${MAILBOX}/vouchers`, { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify(voucher) })
    ok(post.ok, 'mailbox accepted the voucher')
    const back = await (await fetch(`${MAILBOX}/vouchers?eventId=${eid}&attendee=${acct.att1.address}&chainId=31337&contract=${CONTRACT}`)).json()
    ok(back.ticketSig === t.toLowerCase() && back.presenceSig === p.toLowerCase(), 'mailbox returned the same voucher')
  }

  console.log(`\nALL PASS (${pass} assertions)`)
}
main().catch((e) => {
  console.error(e.message || e)
  process.exit(1)
})
