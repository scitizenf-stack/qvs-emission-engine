#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
cd "$ROOT"

mkdir -p programs/qvs_emission_engine/src tests docs scripts
cat > .gitignore <<'EOF'
target/
node_modules/
.anchor/
.npm/
.env
*.log
coverage/
EOF

cat > Cargo.toml <<'EOF'
[workspace]
members = [
  "programs/qvs_emission_engine",
]
resolver = "2"
EOF

cat > Anchor.toml <<'EOF'
[features]
seeds = false

[programs.localnet]
qvs_emission_engine = "Fg6PaFpoGXkYsidMpWTK6W2BeZ7FEfcYkg476zPFsLnS"

[provider]
cluster = "Localnet"
wallet = "~/.config/solana/id.json"
EOF

echo "Repository scaffold updated."
