#!/usr/bin/env bash
set -e

if [ "$#" -ne 2 ]; then
  echo "Usage: $0 <MINT_ADDRESS> <DEST_ACCOUNT>" >&2
  exit 1
fi

MINT=$1
DEST=$2
AMOUNT=1000000000

echo "Minting ${AMOUNT} tokens to ${DEST}..."
TX=$(spl-token mint "$MINT" "$AMOUNT" "$DEST")
if [ -z "$TX" ]; then
  echo "Mint failed." >&2
  exit 1
fi

echo "MINT_TX_SIG=${TX}"
