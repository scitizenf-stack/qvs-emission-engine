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

## Client scripts

```powershell
node scripts/initialize.js
node scripts/emit.js
node scripts/read_state.js
```

See [docs/DEVELOPER.md](docs/DEVELOPER.md) for the emission math and deployment steps.
