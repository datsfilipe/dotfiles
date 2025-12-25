#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

URL="https://tableplus.com/release/linux/x64/TablePlus-x64.AppImage"

NEW_HASH=$(nix-prefetch-url $URL)

cat > "$SCRIPT_DIR/source.json" << EOF
{
  "sha256": "${NEW_HASH}",
  "version": "latest"
}
EOF

echo "updated source.json with new hash: ${NEW_HASH}"
