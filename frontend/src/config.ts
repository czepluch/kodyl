// Chain / contract / account configuration for the local-testnet demo.
//
// The contract is impersonated through anvil's unlocked default accounts (no
// MetaMask needed): reads go through a viem public client, writes through a
// per-account wallet client, and the lifecycle clock is driven by a viem test
// client. wagmi provides the React config/provider.
import { http, createConfig } from 'wagmi'
import { foundry } from 'wagmi/chains'
import { type Abi, type Hex, createPublicClient, createTestClient, createWalletClient } from 'viem'
import { privateKeyToAccount } from 'viem/accounts'
import abiJson from './kodylAbi.json'
import deployment from './deployment.json'

export const abi = abiJson as Abi
export const CONTRACT = deployment.address as `0x${string}`
export const RPC_URL = (deployment as { rpcUrl?: string }).rpcUrl ?? 'http://127.0.0.1:8545'

// Point the Foundry chain (id 31337) at the deployment's RPC.
export const chain = {
  ...foundry,
  rpcUrls: { default: { http: [RPC_URL] }, public: { http: [RPC_URL] } },
}

export const wagmiConfig = createConfig({
  chains: [chain],
  transports: { [chain.id]: http(RPC_URL, { batch: true }) },
})

// batch: true coalesces the many per-tick eth_calls into single HTTP requests
// (anvil has no Multicall3). pollingInterval drives watchBlocks below.
export const publicClient = createPublicClient({
  chain,
  transport: http(RPC_URL, { batch: true }),
  pollingInterval: 1500,
})
export const testClient = createTestClient({ chain, mode: 'anvil', transport: http(RPC_URL) })

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

export function walletFor(pk: Hex) {
  return createWalletClient({ account: privateKeyToAccount(pk), chain, transport: http(RPC_URL) })
}

// ADT ordinals exposed across the ABI boundary as uint256 (see Kodyl.solc).
export const STATE_LABELS = ['Registration', 'Active', 'Dispute', 'Settled', 'Cancelled'] as const
export const STATUS_LABELS = ['None', 'Registered', 'Cancelled', 'Checked in', 'Claimed'] as const
