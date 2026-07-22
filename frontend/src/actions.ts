// Write actions and the lifecycle-clock control. Writes are sent from the
// selected anvil account (impersonated) and awaited to a receipt; revert
// reasons are decoded against the hand-authored ABI (which carries the errors
// the compiler could not emit).
import { type Hex, BaseError, ContractFunctionRevertedError } from 'viem'
import { abi, CONTRACT, publicClient, testClient, walletFor } from './config'

export async function send(pk: Hex, functionName: string, args: unknown[], value?: bigint): Promise<void> {
  const wallet = walletFor(pk)
  const hash = await wallet.writeContract({ address: CONTRACT, abi, functionName, args, value })
  const receipt = await publicClient.waitForTransactionReceipt({ hash })
  if (receipt.status !== 'success') throw new Error('transaction reverted')
}

// Turn a viem revert into the contract's named error, e.g. "PayoutSwept" or
// "InvalidEventParameters(Deposit must be > 0)".
export function decodeError(err: unknown): string {
  if (err instanceof BaseError) {
    const revert = err.walk((e) => e instanceof ContractFunctionRevertedError)
    if (revert instanceof ContractFunctionRevertedError && revert.data) {
      const { errorName, args } = revert.data
      return args && args.length ? `${errorName}(${args.join(', ')})` : errorName
    }
    return err.shortMessage
  }
  return err instanceof Error ? err.message : String(err)
}

// --- lifecycle clock (anvil time control) ---

export async function warpBy(seconds: number): Promise<void> {
  const block = await publicClient.getBlock()
  await testClient.setNextBlockTimestamp({ timestamp: block.timestamp + BigInt(seconds) })
  await testClient.mine({ blocks: 1 })
}

export async function warpTo(unixTs: bigint): Promise<void> {
  const block = await publicClient.getBlock()
  // Never move time backwards (the EVM forbids it).
  const target = unixTs > block.timestamp ? unixTs : block.timestamp + 1n
  await testClient.setNextBlockTimestamp({ timestamp: target })
  await testClient.mine({ blocks: 1 })
}
