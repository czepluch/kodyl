// Identity + signing, with two modes toggled at runtime:
//  - demo:   impersonate one of anvil's unlocked accounts (frictionless talks)
//  - wallet: a real injected wallet via viem's custom(window.ethereum) transport
// "me" is a single address either way; sendTx routes to the right signer.
//
// GATE: demo mode exists only when the deployment is local anvil (31337). Off
// it the mode starts at - and is pinned to - wallet, so no path reaches the
// compiled-in dev keys (walletFor throws off-chain-31337 as a second wall).
import { useCallback, useEffect, useMemo, useRef, useState } from 'react'
import { type Hex, type WalletClient, createWalletClient, custom } from 'viem'
import { ACCOUNTS, CONTRACT, RPC_URL, abi, chain, isLocalChain, publicClient, walletFor } from './config'

const ZERO = '0x0000000000000000000000000000000000000000' as const

export type Mode = 'demo' | 'wallet'

type Eip1193 = {
  request: (args: { method: string; params?: unknown[] }) => Promise<unknown>
  on?: (event: string, fn: (payload: any) => void) => void
  removeListener?: (event: string, fn: (payload: any) => void) => void
}

// Wallet on a different chain than the deployment: ask it to switch
// (EIP-3326), adding the chain first if it is unknown (EIP-3085).
async function ensureChain(eth: Eip1193): Promise<void> {
  const current = Number(await eth.request({ method: 'eth_chainId' }))
  if (current === chain.id) return
  const chainId = `0x${chain.id.toString(16)}`
  try {
    await eth.request({ method: 'wallet_switchEthereumChain', params: [{ chainId }] })
  } catch {
    await eth.request({
      method: 'wallet_addEthereumChain',
      params: [{ chainId, chainName: chain.name, nativeCurrency: chain.nativeCurrency, rpcUrls: [RPC_URL] }],
    })
  }
}

export type Session = {
  mode: Mode
  address: `0x${string}`
  connected: boolean
  demoIdx: number
  setDemoIdx: (i: number) => void
  useDemo: () => void
  connect: () => Promise<void>
  sendTx: (functionName: string, args: unknown[], value?: bigint) => Promise<void>
}

export function useSession(): Session {
  const [mode, setMode] = useState<Mode>(isLocalChain ? 'demo' : 'wallet')
  const [demoIdx, setDemoIdx] = useState(0)
  const [walletAddr, setWalletAddr] = useState<`0x${string}` | null>(null)
  const [wallet, setWallet] = useState<WalletClient | null>(null)
  const unhook = useRef<(() => void) | null>(null)

  const address = mode === 'wallet' ? walletAddr ?? ZERO : ACCOUNTS[demoIdx].address
  const connected = mode === 'demo' || walletAddr !== null

  const useDemo = useCallback(() => {
    if (isLocalChain) setMode('demo')
  }, [])

  useEffect(() => () => unhook.current?.(), [])

  const connect = useCallback(async () => {
    const eth = (window as unknown as { ethereum?: Eip1193 }).ethereum
    if (!eth)
      throw new Error(
        isLocalChain
          ? 'No injected wallet found - install MetaMask and point it at the anvil RPC.'
          : `No injected wallet found - install MetaMask and connect it to ${chain.name} (chain ${chain.id}).`,
      )
    const wc = createWalletClient({ chain, transport: custom(eth as never) })
    const [addr] = await wc.requestAddresses()
    await ensureChain(eth) // refusing the switch fails the connect, loudly
    // Track the injected provider; replace (never stack) previous listeners.
    const onAccounts = (accounts: string[]) =>
      setWalletAddr(accounts.length ? (accounts[0] as `0x${string}`) : null) // empty = disconnected
    const onChain = () => ensureChain(eth).catch(() => {})
    unhook.current?.()
    eth.on?.('accountsChanged', onAccounts)
    eth.on?.('chainChanged', onChain)
    unhook.current = () => {
      eth.removeListener?.('accountsChanged', onAccounts)
      eth.removeListener?.('chainChanged', onChain)
    }
    setWallet(wc)
    setWalletAddr(addr)
    setMode('wallet')
  }, [])

  const sendTx = useCallback(
    async (functionName: string, args: unknown[], value?: bigint) => {
      let hash: Hex
      if (mode === 'wallet') {
        if (!wallet || !walletAddr) throw new Error('Connect a wallet first.')
        hash = await wallet.writeContract({
          account: walletAddr,
          address: CONTRACT,
          abi,
          functionName,
          args,
          value,
          chain,
        })
      } else {
        hash = await walletFor(ACCOUNTS[demoIdx].pk).writeContract({
          address: CONTRACT,
          abi,
          functionName,
          args,
          value,
        })
      }
      const receipt = await publicClient.waitForTransactionReceipt({ hash })
      if (receipt.status !== 'success') throw new Error('transaction reverted')
    },
    [mode, wallet, walletAddr, demoIdx],
  )

  return useMemo(
    () => ({ mode, address, connected, demoIdx, setDemoIdx, useDemo, connect, sendTx }),
    [mode, address, connected, demoIdx, useDemo, connect, sendTx],
  )
}
