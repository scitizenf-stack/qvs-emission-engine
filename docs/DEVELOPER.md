# Developer guide

## Emission model

The program stores a single `GlobalState` account that tracks:

- `genesis_timestamp`
- `total_emitted`
- `bump`
- `paused`
- `max_emission_pool`
- `governance`

The emission schedule is intentionally simple and deterministic:

- each halving era is one year in seconds
- the base emission is `1_000_000_000` native units (`1 QVS` at 9 decimals)
- each era halves the issuance rate
- `max_emission_pool` prevents runaway supply

The calculation is implemented in `programs/qvs_emission_engine/src/halving.rs` and is kept immutable by design.

## Local validation

```powershell
solana-test-validator --reset
$env:ANCHOR_PROVIDER_URL = "http://127.0.0.1:8899"
anchor test
```

## Mint authority transfer

After a mint is created, transfer mint authority to the program PDA so the program owns the minting authority:

```bash
spl-token authorize <MINT_ADDRESS> mint --new-authority <PDA_ADDRESS>
```

## Common commands

```bash
# initialize state
node scripts/initialize.js

# emit a scheduled mint
node scripts/emit.js

# read program state
node scripts/read_state.js
```
