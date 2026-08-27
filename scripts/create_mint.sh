#!/usr/bin/env bash
set -euo pipefail

# Robust SPL token mint creation script with retries for create-account
# Outputs:
#   MINT_ADDRESS=<mint>
#   DEST_ACCOUNT=<destination token account>

command -v spl-token >/dev/null 2>&1 || { echo "spl-token not found in PATH" >&2; exit 2; }

echo "Creating SPL token mint with 9 decimals..."
# parse the Address: line which is stable across versions
MINT=$(spl-token create-token --decimals 9 2>&1 | awk '/^Address:/ {print $2; exit}')
if [ -z "${MINT:-}" ]; then
  echo "Failed to create mint. Full command output:" >&2
  spl-token create-token --decimals 9 || true
  exit 1
fi

echo "MINT_ADDRESS=${MINT}"

echo "Creating a token account to receive genesis tokens..."

# Retry create-account (sometimes local validator needs time to index the new mint)
MAX_ATTEMPTS=5
SLEEP_SECS=1
DEST=""
for i in $(seq 1 $MAX_ATTEMPTS); do
  echo "Attempt $i to create account for mint $MINT..."
  OUT=$(spl-token create-account "$MINT" 2>&1) || true
  echo "$OUT" | awk '/^Creating account/ {print $NF; exit}' >/tmp/_dest || true
  DEST=$(cat /tmp/_dest 2>/dev/null || true)
  if [ -n "$DEST" ]; then
    echo "DEST_ACCOUNT=${DEST}"
    exit 0
  fi
  echo "create-account attempt $i failed, output:" >&2
  echo "$OUT" >&2
  if [ $i -lt $MAX_ATTEMPTS ]; then
    echo "Sleeping $SLEEP_SECS seconds before retrying..."
    sleep $SLEEP_SECS
  fi
done

# If we get here, all attempts failed
echo "Failed to create destination account after $MAX_ATTEMPTS attempts. Last output:" >&2
echo "$OUT" >&2
exit 1
