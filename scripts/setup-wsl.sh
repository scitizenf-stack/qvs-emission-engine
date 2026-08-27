#!/usr/bin/env bash
set -euo pipefail

# setup-wsl.sh - installs Solana, Anchor, Rust, Node, and common build deps for Anchor/Solana development
# Usage: bash scripts/setup-wsl.sh

echo "Updating apt and installing prerequisites"
sudo apt-get update
sudo apt-get install -y build-essential pkg-config libudev-dev clang lld llvm-dev libclang-dev git curl unzip ca-certificates

echo "Installing Node.js 20 (NodeSource)"
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install -y nodejs

echo "Installing Rust (rustup)"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source "$HOME/.cargo/env"

echo "Installing Solana CLI v1.18.25"
sh -c "$(curl -sSfL https://release.solana.com/v1.18.25/install)"
export PATH="$HOME/.local/share/solana/install/active_release/bin:$PATH"

echo "Installing Anchor CLI via cargo (v1.1.2)"
cargo install --git https://github.com/coral-xyz/anchor --tag v1.1.2 anchor-cli --locked || true

echo "Verifying installations"
solana --version || true
anchor --version || true
node -v || true
npm -v || true

cat <<'EOF'

Done. Next steps:
  cd /path/to/qvs-emission-engine
  anchor build
  solana-test-validator --reset > /tmp/solana-validator.log 2>&1 & echo $! > /tmp/solana-validator.pid
  sleep 4
  anchor test -- --nocapture
  kill $(cat /tmp/solana-validator.pid) || true
EOF
