// Identity + signing, with two modes toggled at runtime:
//  - demo:   impersonate one of anvil's unlocked accounts (frictionless talks)
//  - wallet: a real injected wallet via viem's custom(window.ethereum) transport
// "me" is a single address either way; sendTx routes to the right signer.
import { useCallback, useMemo, useState } from 'react'
import { type Hex, type WalletClient, createWalletClient, custom } from 'viem'
import { ACCOUNTS, CONTRACT, abi, chain, publicClient, walletFor } from './config'

const ZERO = '0x0000000000000000000000000000000000000000' as const

export type Mode = 'demo' | 'wallet'

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
  const [mode, setMode] = useState<Mode>('demo')
  const [demoIdx, setDemoIdx] = useState(0)
  const [walletAddr, setWalletAddr] = useState<`0x${string}` | null>(null)
  const [wallet, setWallet] = useState<WalletClient | null>(null)

  const address = mode === 'wallet' ? walletAddr ?? ZERO : ACCOUNTS[demoIdx].address
  const connected = mode === 'demo' || walletAddr !== null

  const useDemo = useCallback(() => setMode('demo'), [])

  const connect = useCallback(async () => {
    const eth = (window as unknown as { ethereum?: unknown }).ethereum
    if (!eth) throw new Error('No injected wallet found - install MetaMask and point it at the anvil RPC.')
    const wc = createWalletClient({ chain, transport: custom(eth as never) })
    const [addr] = await wc.requestAddresses()
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
