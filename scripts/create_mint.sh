#!/usr/bin/env bash
set -e

echo "Creating SPL token mint with 9 decimals..."
MINT=$(spl-token create-token --decimals 9 | awk '/Creating token/ {print $NF}')
if [ -z "$MINT" ]; then
  echo "Failed to create mint." >&2
  exit 1
fi

echo "MINT_ADDRESS=${MINT}"
echo "Create an account to receive genesis tokens:"
DEST=$(spl-token create-account "$MINT" | awk '/Creating account/ {print $NF}')
if [ -z "$DEST" ]; then
  echo "Failed to create destination account." >&2
  exit 1
fi

echo "DEST_ACCOUNT=${DEST}"
