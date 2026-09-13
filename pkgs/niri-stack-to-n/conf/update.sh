#!/usr/bin/env bash
set -euo pipefail
source "$(git rev-parse --show-toplevel)/scripts/lib/update-source.sh"
SCRIPT_DIR=$(script_dir)
LATEST_COMMIT=$(curl -s https://api.github.com/repos/FarokhRaad/niri-stack-to-n/commits/main | jq -r .sha)
HASH=$(nix-prefetch-url --unpack "https://github.com/FarokhRaad/niri-stack-to-n/archive/${LATEST_COMMIT}.tar.gz")
NEW_HASH=$(to_sri "$HASH")
cat >"$SCRIPT_DIR/source.json" <<EOF
{
  "rev": "${LATEST_COMMIT}",
  "hash": "${NEW_HASH}"
}
EOF
echo "Updated source.json with rev: ${LATEST_COMMIT}, hash: ${NEW_HASH}"
