# Developer Guide

Use a local validator for end-to-end execution.

## Local validation

```bash
solana-test-validator --reset
anchor test -- --nocapture
```

## Build

```bash
anchor build
```

## Common caveats

- Keep the program ID stable in `Anchor.toml` when moving between local and CI environments.
- Use WSL for local runtime validation when the Windows host is inconsistent.
- Keep scripts in `scripts/` simple and CLI-driven.
