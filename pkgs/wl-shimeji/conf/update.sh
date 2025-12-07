#!/usr/bin/env nix-shell
#!nix-shell -i bash -p git nix-prefetch-git jq

set -euo pipefail

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
REPO_URL="https://github.com/CluelessCatBurger/wl_shimeji"

echo "Fetching latest revision..."
REV=$(git ls-remote "$REPO_URL" main | awk '{print $1}')
echo "Latest rev: $REV"

echo "Calculating hash (fetching submodules)..."
JSON_OUTPUT=$(nix-prefetch-git "$REPO_URL" --rev "$REV" --fetch-submodules --quiet)
HASH=$(echo "$JSON_OUTPUT" | jq -r '.hash')

echo "Calculated hash: $HASH"

cat > "$SCRIPT_DIR/source.json" << EOF
{
  "rev": "${REV}",
  "hash": "${HASH}"
}
EOF

echo "Updated source.json successfully."
