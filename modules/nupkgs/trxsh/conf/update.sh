#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
URL="https://github.com/datsfilipe/trxsh/releases/download/v1.0.0/trxsh-v1.0.0-linux-amd64.tar.gz"

HASH=$(nix-prefetch-url "$URL")
NEW_HASH=$(nix hash convert --hash-algo sha256 --to base64 "$HASH")

cat > "$SCRIPT_DIR/source.json" <<EOF
{
  "sha256": "${NEW_HASH}",
  "version": "v1.0.0"
}
EOF

echo "Updated source.json with new hash: ${NEW_HASH}"
