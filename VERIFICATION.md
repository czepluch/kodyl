# Verifying a Kodyl deployment

There is no Solidity source for this contract, so the usual verification
routes do not apply: Etherscan source verification has nothing to compile
(the source is Core Solidity, a language Etherscan does not know), and no
Sourcify metadata exists (the pipeline's `solc --strict-assembly` step emits
no metadata hash). What this repo offers instead is a reproducible-build
claim that a third party can check with the commands below.

## What is deployed

- **Initcode**: [`core/build/Kodyl.hex`](./core/build/Kodyl.hex) (10252
  bytes, committed) with the ABI-encoded constructor argument appended - one
  `address` (the dust maintainer), exactly as Solidity would append it:

  ```shell
  cast send --create "0x$(cat core/build/Kodyl.hex)$(cast abi-encode 'c(address)' "$MAINTAINER" | cut -c3-)"
  ```

- **Runtime**: the trailing 10051 bytes of the initcode - the deploy code is
  the leading 201 bytes, and the runtime object contains no metadata hash and
  no immutables, so the on-chain code is byte-equal to that tail for every
  deployment regardless of constructor argument.
- **ABI of record**: [`test/KodylAbi.sol`](./test/KodylAbi.sol). The Core
  Solidity compiler's ABI emitter covers functions only; the events and
  errors are hand-rolled in source, so the hand-authored interface is the
  source of truth (`scripts/sync-abi.sh` generates the frontend copy from
  it, and the forge suite proves selector/topic/payload compatibility
  byte-for-byte).

## Reproduce the bytecode

The committed artifacts (`core/build/*.hex`, `core/build/*.yul`) are the
claim; rebuilding them from source at the pinned toolchain must produce
byte-identical files, or the claim fails. Requires nix.

```shell
git clone https://github.com/argotorg/solcore
git -C solcore checkout "$(awk '/^solcore_rev/{print $2}' core/build/TOOLCHAIN)"
./scripts/pin-toolchain.sh ./solcore     # nix-builds sol-core/yule, snapshots std
./scripts/check-core.sh                  # .solc -> hull -> Yul -> hex
git diff --exit-code -- core/build/Kodyl.hex core/build/Probe.hex \
                        core/build/Kodyl.yul core/build/Probe.yul
```

An empty diff (exit 0) is the pass condition. `core/build/TOOLCHAIN` is
deliberately left out of the diff: it stamps the sha256 of the toolchain
binaries, and a fresh nix build of a GHC-produced binary is not guaranteed
bit-identical to the build that stamped it - the hex/yul outputs are.

CI runs this exact check (`reproduce-core` in
[`.github/workflows/ci.yml`](./.github/workflows/ci.yml)) on every change to
`core/` or `scripts/`, so reproducibility is re-proven continuously, not
just claimed once.

## Verify a deployment

Each live deployment has a committed record, `deployments/<chainid>.json`
(see [`deployments/README.md`](./deployments/README.md)). To check that the
code at the recorded address is what this repo builds:

```shell
REC=deployments/11155111.json            # the record for the chain in question
ADDR="$(jq -r .address "$REC")"
RPC=...                                  # any node for that chain

# 1. On-chain runtime == the trailing 10051 bytes (20102 hex chars) of the initcode.
[ "$(cast code --rpc-url "$RPC" "$ADDR")" = "0x$(tail -c 20102 core/build/Kodyl.hex)" ] \
    && echo "runtime matches"

# 2. The record's initcode hash == the committed (and reproducible) hex.
[ "$(jq -r .initcodeSha256 "$REC")" = "$(sha256sum core/build/Kodyl.hex | cut -d' ' -f1)" ] \
    && echo "initcode hash matches"

# 3. The record's toolchain rev == the build stamp.
[ "$(jq -r .solcoreRev "$REC")" = "$(awk '/^solcore_rev/{print $2}' core/build/TOOLCHAIN)" ] \
    && echo "toolchain rev matches"
```

Combined with the reproduce step above, this closes the chain: source at
this repo's HEAD -> pinned toolchain -> committed initcode -> on-chain
runtime. `deployBlock` in the record is the log-scan floor the frontend
uses, and `chainId` must match `cast chain-id --rpc-url "$RPC"`.

## Etherscan, best-effort

Etherscan can verify Yul sources in some configurations. The generated
[`core/build/Kodyl.yul`](./core/build/Kodyl.yul) plus the stamped compiler
(solc 0.8.28, strict assembly, optimizer enabled) MAY verify there as a
bonus - worth attempting, but it is not the verification story; the
reproduce-and-diff recipe above is.
