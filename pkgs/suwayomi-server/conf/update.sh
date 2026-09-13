#!/usr/bin/env bash
set -euo pipefail

source "$(git rev-parse --show-toplevel)/scripts/lib/update-source.sh"
SCRIPT_DIR=$(script_dir)
TAG=$(github_latest_tag Suwayomi/Suwayomi-Server)
VERSION="${TAG#v}"

URL="https://github.com/Suwayomi/Suwayomi-Server/releases/download/${TAG}/Suwayomi-Server-${TAG}.jar"
NEW_HASH=$(to_sri "$(nix-prefetch-url "$URL")")

cat >"$SCRIPT_DIR/source.json" <<EOF
{
  "sha256": "${NEW_HASH}",
  "version": "${VERSION}"
}
EOF

echo "updated source.json to ${VERSION} (${NEW_HASH})"
