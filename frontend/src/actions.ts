// Revert decoding and the lifecycle-clock control. Writes live in session.ts
// (sendTx); revert reasons are decoded against the hand-authored ABI (which
// carries the errors the compiler could not emit). The clock controls exist
// only on the local anvil chain - testClient is null everywhere else.
import { BaseError, ContractFunctionRevertedError } from 'viem'
import { STATUS_LABELS, publicClient, testClient } from './config'
import { fmtEth } from './format'

const statusLabel = (v: unknown) => STATUS_LABELS[Number(v)] ?? String(v)

// One short neutral sentence per contract error (names from kodylAbi.json).
// Anything unmapped falls back to the raw Name(args) form below.
const FRIENDLY: Record<string, (args: readonly unknown[]) => string> = {
  EventNotFound: () => 'That event does not exist.',
  RegistrationClosed: () => 'Registration is closed for this event.',
  AlreadyRegistered: () => 'This address is already registered.',
  IncorrectDeposit: (a) =>
    a.length >= 2
      ? `The deposit must be exactly ${fmtEth(a[0] as bigint)} (got ${fmtEth(a[1] as bigint)}).`
      : 'The deposit does not match the required amount.',
  EventFull: () => 'The event is full.',
  CancellationDeadlinePassed: () => 'The cancellation deadline has passed.',
  EventNotCancelled: () => 'The event is not cancelled, so there is no refund.',
  NotSettled: () => 'The event is not settled yet.',
  PayoutSwept: () => 'The payout was swept to the maintainer after the claim timeout.',
  CheckInWindowClosed: () => 'The check-in window has closed.',
  BatchTooLarge: (a) =>
    a.length >= 2 ? `The batch has ${a[0]} attendees; the limit is ${a[1]}.` : 'The check-in batch is too large.',
  NotOrganizer: () => 'Only the event organizer can do that.',
  NotAuthorized: () => 'This account is not authorized to do that.',
  DustNotClaimable: () => 'Dust is not claimable yet: payouts are still unclaimed and the timeout has not passed.',
  InvalidAttendeeStatus: (a) =>
    a.length >= 2
      ? `The attendee status is ${statusLabel(a[0])}, but this action requires ${statusLabel(a[1])}.`
      : 'The attendee status does not allow this action.',
  InvalidEventParameters: (a) => (a.length ? String(a[0]) : 'The event parameters are invalid.'),
  TransferFailed: () => 'The ETH transfer failed.',
  NonPayableReceivedValue: () => 'This function does not accept ETH.',
  DirtyHigherBitsForAddress: () => 'The address argument is malformed (non-zero upper bits).',
  EventAlreadyStarted: () => 'The event has already started.',
  // Proof-based check-in.
  TicketSignerMismatch: () => 'The ticket signature does not match the claimed attendee.',
  PresenceSignerUnauthorized: () => 'The presence signature is not from the organizer or an authorized operator.',
  InvalidSignatureLength: () => 'A signature is malformed (it must be 65 bytes).',
  ProofArrayMismatch: () => 'The batch proof arrays have mismatched lengths.',
  MalleableSignatureRejected: () => 'The signature was rejected as malleable (high-s form).',
  ECRecoverFailed: () => 'A signature could not be recovered to a signer.',
  ECRecoverCallFailed: () => 'Signature recovery failed at the precompile.',
  ArrayOutOfBounds: () => 'A batch index was out of range.',
}

// Turn a viem revert into a human sentence when the error is known, else the
// contract's named form, e.g. "InvalidEventParameters(Deposit must be > 0)".
export function decodeError(err: unknown): string {
  if (err instanceof BaseError) {
    const revert = err.walk((e) => e instanceof ContractFunctionRevertedError)
    if (revert instanceof ContractFunctionRevertedError && revert.data) {
      const { errorName, args } = revert.data
      const friendly = FRIENDLY[errorName]
      if (friendly) return friendly(args ?? [])
      return args && args.length ? `${errorName}(${args.join(', ')})` : errorName
    }
    return err.shortMessage
  }
  return err instanceof Error ? err.message : String(err)
}

// --- lifecycle clock (anvil time control; local chain only) ---

function clock() {
  if (!testClient) throw new Error('Chain-clock control exists only on the local anvil chain.')
  return testClient
}

export async function warpBy(seconds: number): Promise<void> {
  const tc = clock()
  const block = await publicClient.getBlock()
  await tc.setNextBlockTimestamp({ timestamp: block.timestamp + BigInt(seconds) })
  await tc.mine({ blocks: 1 })
}

export async function warpTo(unixTs: bigint): Promise<void> {
  const tc = clock()
  const block = await publicClient.getBlock()
  // Never move time backwards (the EVM forbids it).
  const target = unixTs > block.timestamp ? unixTs : block.timestamp + 1n
  await tc.setNextBlockTimestamp({ timestamp: target })
  await tc.mine({ blocks: 1 })
}
