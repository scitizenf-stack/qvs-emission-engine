# Operations Guide

The QVS emission engine relies on a global state account and a small set of authority-controlled instructions.

## Typical operation

1. Deploy the program.
2. Initialize the global state with the authority wallet and emission parameters.
3. Run the emission loop through `emit_epoch`.
4. Pause or resume using `set_paused` when needed.

## Safety rules

- Require the authority signer for administrative changes.
- Prevent emission while paused.
- Keep halving intervals above zero.
- Check for overflow in emission math.
