# QVS Emission Engine

This repository contains a minimal Anchor/Solana program scaffold for the QVS emission engine. The program tracks a global emission state, exposes initialization and epoch-triggered emission logic, and provides a simple local test harness for Anchor-based validation.

## Quick start

1. Install Rust, Solana CLI, and Anchor.
2. Install dependencies:
   npm install
3. Build the program:
   anchor build
4. Run tests:
   anchor test -- --nocapture

## Program flow

- `initialize` creates the global state account.
- `emit_epoch` advances the emission cycle and records the emitted amount.
- `set_paused` toggles the runtime pause flag.

## Scripts

- `scripts/create_mint.sh` creates a local SPL token mint and destination account.
- `scripts/transfer_authority.js` prints the authority-transfer command for mint governance.
