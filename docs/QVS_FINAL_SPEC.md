# QVS Final Spec

This document captures the target behavior of the QVS emission engine at the Phase‑1 scaffold level.

## Core state

The program stores a single global state account with the following fields:

- authority
- paused flag
- current epoch
- total emitted
- current emission
- halving interval
- max emissions
- bump seed

## Instructions

### initialize
Creates the state account and seeds the engine with an authority and emission schedule.

### emit_epoch
Advances the emission epoch, computes the current emission amount, and persists the totals.

### set_paused
Allows the authority to pause or resume the engine.

## Notes

The implementation is intentionally compact and is designed to be a valid Anchor foundation for further QVS logic.
