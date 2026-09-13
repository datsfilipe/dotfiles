#!/usr/bin/env bash
set -euo pipefail
source "$(git rev-parse --show-toplevel)/scripts/lib/update-source.sh"
SCRIPT_DIR=$(script_dir)
VERSION=$(github_latest_tag datsfilipe/trxsh)
URL="https://github.com/datsfilipe/trxsh/releases/download/${VERSION}/trxsh-${VERSION}-linux-amd64.tar.gz"
HASH=$(nix-prefetch-url "$URL")
NEW_HASH=$(nix hash convert --hash-algo sha256 --to base64 "$HASH")
cat >"$SCRIPT_DIR/source.json" <<EOF
{
  "sha256": "${NEW_HASH}",
  "version": "${VERSION}"
}
EOF
echo "Updated source.json with new hash: ${NEW_HASH} for version: ${VERSION}"
