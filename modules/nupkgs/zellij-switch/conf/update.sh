#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
REPO="mostafaqanbaryan/zellij-switch"

LATEST=$(curl -s "https://api.github.com/repos/${REPO}/releases/latest")
VERSION=$(echo "$LATEST" | jq -r .tag_name)
ASSET_URL=$(echo "$LATEST" | jq -r '.assets[] | select(.name=="zellij-switch.wasm") | .browser_download_url')

NEW_HASH=$(nix hash convert --hash-algo sha256 --to base64 $(nix-prefetch-url "$ASSET_URL"))

cat > "$SCRIPT_DIR/source.json" << EOF
{
  "version": "${VERSION}",
  "url": "${ASSET_URL}",
  "sha256": "${NEW_HASH}"
}
EOF

echo "updated source.json - version: ${VERSION}, hash: ${NEW_HASH}"
