#!/usr/bin/env bash
set -euo pipefail

source "$(git rev-parse --show-toplevel)/scripts/lib/update-source.sh"
SCRIPT_DIR=$(script_dir)

URL="https://tableplus.com/release/linux/x64/TablePlus-x64.AppImage"

NEW_HASH=$(nix-prefetch-url $URL)

cat >"$SCRIPT_DIR/source.json" <<EOF
{
  "sha256": "${NEW_HASH}",
  "version": "latest"
}
EOF

echo "updated source.json with new hash: ${NEW_HASH}"
