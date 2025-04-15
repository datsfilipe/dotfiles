#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LATEST_RELEASE=$(curl -s https://api.github.com/repos/datsfilipe/trxsh/releases/latest)
VERSION=$(echo "$LATEST_RELEASE" | jq -r .tag_name)
URL="https://github.com/datsfilipe/trxsh/releases/download/${VERSION}/trxsh-${VERSION}-linux-amd64.tar.gz"
HASH=$(nix-prefetch-url "$URL")
NEW_HASH=$(nix hash convert --hash-algo sha256 --to base64 "$HASH")
cat > "$SCRIPT_DIR/source.json" <<EOF
{
  "sha256": "${NEW_HASH}",
  "version": "${VERSION}"
}
EOF
echo "Updated source.json with new hash: ${NEW_HASH} for version: ${VERSION}"
