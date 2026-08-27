# Operation guide

## Phase 1: create mint and transfer authority

### Local validator workflow

```powershell
solana-test-validator --reset &
$env:ANCHOR_PROVIDER_URL = "http://127.0.0.1:8899"
anchor test
```

### Devnet workflow

```bash
# create a mint with 9 decimals
./scripts/create_mint.sh
# note MINT_ADDRESS and DEST_ACCOUNT

# mint the genesis allocation (1,000,000,000 human units)
./scripts/mint_genesis.sh <MINT_ADDRESS> <DEST_ACCOUNT>

# print the PDA plus the exact authority transfer command
node scripts/transfer_authority.js <PROGRAM_ID> <MINT_ADDRESS>
# then run the printed `spl-token authorize ...` command
```

### Authority transfer

After mint deployment and genesis minting, transfer mint authority to the program PDA so only the program can mint further:

```bash
spl-token authorize <MINT_ADDRESS> mint --new-authority <PDA_ADDRESS>
```

If governance decides to burn human authority permanently:

```bash
spl-token authorize <MINT_ADDRESS> mint --new-authority 11111111111111111111111111111111
```

## Notes

- Use a funded wallet or funded local validator keys before any devnet action.
- For local verification, avoid Devnet airdrops and run against `solana-test-validator`.
- The repo intentionally excludes any Phase-3 custody or auction logic. The program is a pure emission engine.
