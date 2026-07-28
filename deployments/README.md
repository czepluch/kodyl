# Deployments

One committed record per live network, named `<chainid>.json` and written by
[`scripts/deploy-testnet.sh`](../scripts/deploy-testnet.sh) (Sepolia would be
`11155111.json`). Local anvil deployments are ephemeral by design and never
get a record here: `scripts/deploy-anvil.sh` writes straight to
`frontend/src/deployment.json`, which points at whatever node you ran last.

## Record shape

```json
{
  "address": "0x...",          // the deployed singleton
  "chainId": 11155111,
  "rpcUrl": "https://...",     // the node used to deploy (edit out API keys before committing)
  "deployBlock": 123456,       // log-scan floor for the frontend
  "initcodeSha256": "...",     // sha256 of core/build/Kodyl.hex at deploy time
  "solcoreRev": "...",         // toolchain rev from core/build/TOOLCHAIN
  "timestamp": "2026-01-01T00:00:00Z"
}
```

The first four fields are exactly the frontend's `deployment.json` shape, so
pointing the demo at a record is a copy:

```shell
cp deployments/11155111.json frontend/src/deployment.json
```

The frontend chain-gates all demo affordances (dev-key session picker,
fast-forward) to chain id 31337, so they disappear automatically off-local.

## Verifying a record

A third party can check that the on-chain code is what this repo builds:
rebuild the initcode at the recorded `solcoreRev` (`scripts/pin-toolchain.sh`
then `scripts/check-core.sh`), confirm `sha256sum core/build/Kodyl.hex`
matches `initcodeSha256`, then compare runtime bytecode - deploy the rebuilt
hex locally and diff `cast code` against the recorded address (the runtime
object has no metadata hash or immutables, so byte equality is expected).
