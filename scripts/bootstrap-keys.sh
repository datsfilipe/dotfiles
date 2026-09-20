#!/usr/bin/env bash
set -euo pipefail
umask 077

GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m'

SSH_KEY="$HOME/.ssh/alt_key"
KEY_FILE="/var/lib/sops-nix/key.txt"
SOPS_CONFIG=".sops.yaml"

for bin in ssh-to-age age-keygen sudo; do
  if ! command -v "$bin" >/dev/null 2>&1; then
    echo -e "${RED}error: '$bin' not found in PATH.${NC}"
    exit 1
  fi
done

if [ ! -f "$SOPS_CONFIG" ]; then
  echo -e "${RED}error: $SOPS_CONFIG not found. Run this from the repo root.${NC}"
  exit 1
fi

recipient_is_known() {
  grep -qF "$1" "$SOPS_CONFIG"
}

if [ -f "$KEY_FILE" ] || sudo test -f "$KEY_FILE"; then
  existing=$(sudo age-keygen -y "$KEY_FILE")
  if recipient_is_known "$existing"; then
    echo -e "${GREEN}$KEY_FILE already provisioned ($existing).${NC}"
    exit 0
  fi
  echo -e "${RED}error: $KEY_FILE holds $existing, which is not a recipient in $SOPS_CONFIG.${NC}"
  echo "move it aside and re-run to regenerate from $SSH_KEY."
  exit 1
fi

if [ ! -f "$SSH_KEY" ]; then
  echo -e "${RED}error: neither $KEY_FILE nor $SSH_KEY exists on this host.${NC}"
  echo "copy one of them from a provisioned host, then re-run."
  exit 1
fi

TMP=$(mktemp)
cleanup() {
  rm -f "$TMP"
}
trap cleanup EXIT

ssh-to-age -private-key -i "$SSH_KEY" >"$TMP"
derived=$(age-keygen -y "$TMP")

if ! recipient_is_known "$derived"; then
  echo -e "${RED}error: $SSH_KEY derives $derived, which is not a recipient in $SOPS_CONFIG.${NC}"
  echo "that key cannot decrypt this repo's secrets."
  exit 1
fi

sudo install -D -m 600 -o root -g root "$TMP" "$KEY_FILE"
echo -e "${GREEN}installed $KEY_FILE ($derived).${NC}"
echo -e "${YELLOW}run 'just switch <host>' to populate /run/secrets.${NC}"
