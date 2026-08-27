# QVS Emission Engine

License-free Solana Anchor program for immutable emission logic with a halving schedule and minimal governance hooks. The program intentionally strips escrow, batch auctions, and phase-3 funding flows.

## Features

- immutable global emission state
- genesis initialization with a single authorized governance key
- emission amount based on halving-era math
- pause/unpause guardrails and max pool cap
- local validator friendly setup for deterministic testing

## Quick start

```powershell
# install dependencies
npm install

# build the program
anchor build

# run against a local validator
solana-test-validator --reset
$env:ANCHOR_PROVIDER_URL = "http://127.0.0.1:8899"
anchor test
```

## Phase 1 devnet flow

```bash
# 1) create mint and destination account
./scripts/create_mint.sh
# note MINT_ADDRESS and DEST_ACCOUNT

# 2) mint genesis supply
./scripts/mint_genesis.sh <MINT_ADDRESS> <DEST_ACCOUNT>

# 3) compute the PDA and print the authority-transfer command
node scripts/transfer_authority.js <PROGRAM_ID> <MINT_ADDRESS>
# run the printed `spl-token authorize ...` command
```

## Client scripts

```powershell
node scripts/initialize.js
node scripts/emit.js
node scripts/read_state.js
```

See [docs/DEVELOPER.md](docs/DEVELOPER.md), [docs/OPERATION.md](docs/OPERATION.md), and [docs/QVS_FINAL_SPEC.md](docs/QVS_FINAL_SPEC.md) for the emission math, deployment steps, and full build-ready QVS specification.
