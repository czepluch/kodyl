// Chain / contract / account configuration, driven by the deployment record
// (deployment.json, written by scripts/deploy-anvil.sh).
//
// Reads go through a viem public client. Demo-mode writes (anvil's unlocked
// accounts) and the lifecycle clock exist ONLY on the local chain: the bundled
// dev keys must be structurally unable to sign for anything but 31337.
import { type Abi, type Hex, createPublicClient, createTestClient, createWalletClient, defineChain, http } from 'viem'
import { foundry, mainnet, sepolia } from 'viem/chains'
import { privateKeyToAccount } from 'viem/accounts'
import abiJson from './kodylAbi.json'
import deployment from './deployment.json'

export const abi = abiJson as Abi
export const CONTRACT = deployment.address as `0x${string}`
export const RPC_URL = (deployment as { rpcUrl?: string }).rpcUrl ?? 'http://127.0.0.1:8545'
const CHAIN_ID = deployment.chainId

// THE gate: every anvil-only affordance (dev-key signing, clock control, the
// demo drawer) keys off the recorded chain id, not a build flag.
export const isLocalChain = CHAIN_ID === 31337

const PRESETS = [foundry, sepolia, mainnet]
const base =
  PRESETS.find((c) => c.id === CHAIN_ID) ??
  defineChain({
    id: CHAIN_ID,
    name: `Chain ${CHAIN_ID}`,
    nativeCurrency: { name: 'Ether', symbol: 'ETH', decimals: 18 },
    rpcUrls: { default: { http: [RPC_URL] } },
  })

// Whatever the preset says, RPC traffic goes to the recorded endpoint.
export const chain = {
  ...base,
  rpcUrls: { default: { http: [RPC_URL] }, public: { http: [RPC_URL] } },
}

// batch: true coalesces the many per-tick eth_calls into single HTTP requests
// (anvil has no Multicall3). pollingInterval drives watchBlocks below.
export const publicClient = createPublicClient({
  chain,
  transport: http(RPC_URL, { batch: true }),
  pollingInterval: 1500,
})

// anvil's clock control: null off the local chain, so no code path can hold a
// test client against a public network.
export const testClient = isLocalChain
  ? createTestClient({ chain, mode: 'anvil', transport: http(RPC_URL) })
  : null

// anvil's well-known default accounts. DEV KEYS - local demo only, never real funds.
type Acct = { label: string; role: string; pk: Hex }
const RAW: Acct[] = [
  { label: 'Account 0', role: 'organizer / maintainer', pk: '0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80' },
  { label: 'Account 1', role: 'attendee', pk: '0x59c6995e998f97a5a0044966f0945389dc9e86dae88c7a8412f4603b6b78690d' },
  { label: 'Account 2', role: 'attendee', pk: '0x5de4111afa1a4b94908f83103eb1f1706367c2e68ca870fc3fb9a804cdab365a' },
  { label: 'Account 3', role: 'attendee', pk: '0x7c852118294e51e653712a81e05800f419141751be58f605c371e15141b007a6' },
]

export const ACCOUNTS = RAW.map((a) => ({
  ...a,
  address: privateKeyToAccount(a.pk).address,
}))

// The only constructor of a dev-key signer. Throws before building a wallet
// client when the deployment is not local anvil.
export function walletFor(pk: Hex) {
  if (!isLocalChain) throw new Error('Demo keys sign only on the local anvil chain (31337).')
  return createWalletClient({ account: privateKeyToAccount(pk), chain, transport: http(RPC_URL) })
}

// ADT ordinals exposed across the ABI boundary as uint256 (see Kodyl.solc).
export const STATE_LABELS = ['Registration', 'Active', 'Dispute', 'Settled', 'Cancelled'] as const
export const STATUS_LABELS = ['None', 'Registered', 'Cancelled', 'Checked in', 'Claimed'] as const
