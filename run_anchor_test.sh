#!/usr/bin/env bash
set -euo pipefail
cd /mnt/c/Dev/qvs-emission-engine || { echo "ERROR: project path not found"; exit 2; }
rm -rf .anchor target || true
if [ -f package.json ]; then
  npm ci || npm install || true
fi
pkill -f solana-test-validator || true
solana-test-validator --reset > /tmp/solana-validator.log 2>&1 &
# give validator a moment to start
sleep 2
anchor test --skip-build -- --nocapture 2>&1 | tee /tmp/anchor-test.log
sed -n '1,200p' /tmp/anchor-test.log
