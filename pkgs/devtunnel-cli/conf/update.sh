#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

NEW_HASH=$(nix hash convert --hash-algo sha256 --to base64 $(nix-prefetch-url https://aka.ms/TunnelsCliDownload/linux-x64))

cat > "$SCRIPT_DIR/source.json" << EOF
{
  "sha256": "${NEW_HASH}",
  "version": "latest"
}
EOF

echo "updated source.json with new hash: ${NEW_HASH}"
