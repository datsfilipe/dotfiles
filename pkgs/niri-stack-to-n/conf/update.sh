#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LATEST_COMMIT=$(curl -s https://api.github.com/repos/FarokhRaad/niri-stack-to-n/commits/main | jq -r .sha)
HASH=$(nix-prefetch-url --unpack "https://github.com/FarokhRaad/niri-stack-to-n/archive/${LATEST_COMMIT}.tar.gz")
NEW_HASH=$(nix hash convert --hash-algo sha256 --to sri "$HASH")
cat > "$SCRIPT_DIR/source.json" <<EOF
{
  "rev": "${LATEST_COMMIT}",
  "hash": "${NEW_HASH}"
}
EOF
echo "Updated source.json with rev: ${LATEST_COMMIT}, hash: ${NEW_HASH}"
