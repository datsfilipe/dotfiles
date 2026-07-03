#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

API=$(curl -fsSL https://api.github.com/repos/Suwayomi/Suwayomi-Server/releases/latest)
TAG=$(printf '%s' "$API" | grep '"tag_name"' | head -n1 | cut -d'"' -f4)
VERSION="${TAG#v}"

URL="https://github.com/Suwayomi/Suwayomi-Server/releases/download/${TAG}/Suwayomi-Server-${TAG}.jar"
NEW_HASH=$(nix hash convert --hash-algo sha256 --to sri "$(nix-prefetch-url "$URL")")

cat > "$SCRIPT_DIR/source.json" << EOF
{
  "sha256": "${NEW_HASH}",
  "version": "${VERSION}"
}
EOF

echo "updated source.json to ${VERSION} (${NEW_HASH})"
