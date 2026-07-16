#!/usr/bin/env bash
set -euo pipefail

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

SECRET="/run/secrets/rclone/config"
TMP="/tmp/rclone.conf"

if [ ! -f "$SECRET" ]; then
  echo -e "${RED}error: $SECRET not found. Is the gdrive service enabled on this host?${NC}"
  exit 1
fi

for bin in rclone jq wl-copy just; do
  if ! command -v "$bin" >/dev/null 2>&1; then
    echo -e "${RED}error: '$bin' not found in PATH.${NC}"
    exit 1
  fi
done

cleanup() {
  rm -f "$TMP"
}
trap cleanup EXIT

cp "$SECRET" "$TMP"
chmod 600 "$TMP"

echo "reconnecting gdrive (a browser window will open)..."
rclone config reconnect gdrive: --config "$TMP"

jq -Rs . <"$TMP" | wl-copy
echo -e "${GREEN}refreshed config copied to clipboard (escaped string).${NC}"
echo "paste it as the rclone/config value in the sops editor, then save and quit."

just secrets

echo -e "${GREEN}done. run 'just switch <host>' to apply, then restart rclone-gdrive-mount.${NC}"
