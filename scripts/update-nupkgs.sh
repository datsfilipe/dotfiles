#!/usr/bin/env bash
set -uo pipefail

PKGS_DIR="./pkgs"
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

if [ ! -d "$PKGS_DIR" ]; then
  echo "error: '$PKGS_DIR' not found. Run this from your dotfiles root."
  exit 1
fi

TARGET="${1:-}"
SCRIPTS=()
FAILED_LOGS=()

if [ -n "$TARGET" ]; then
  SPECIFIC_SCRIPT="$PKGS_DIR/$TARGET/conf/update.sh"
  if [ -f "$SPECIFIC_SCRIPT" ]; then
    SCRIPTS+=("$SPECIFIC_SCRIPT")
  else
    echo "error: package '$TARGET' not found at $SPECIFIC_SCRIPT"
    exit 1
  fi
else
  echo "scanning packages..."
  while IFS= read -r script; do
    SCRIPTS+=("$script")
  done < <(find "$PKGS_DIR" -mindepth 3 -maxdepth 3 -path "*/conf/update.sh" | sort)
fi

if [ ${#SCRIPTS[@]} -eq 0 ]; then
  echo "no update scripts found."
  exit 0
fi

echo "updating ${#SCRIPTS[@]} packages..."
echo "--------------------------------"

success_count=0
fail_count=0

for script in "${SCRIPTS[@]}"; do
  pkg_name=$(basename "$(dirname "$(dirname "$script")")")

  printf "• %-20s " "$pkg_name"

  chmod +x "$script"

  if output=$("$script" 2>&1); then
    printf "${GREEN}[OK]${NC}\n"
    ((success_count++))
  else
    printf "${RED}[FAIL]${NC}\n"
    ((fail_count++))
    FAILED_LOGS+=("Package: $pkg_name\nScript: $script\nOutput:\n$output\n")
  fi
done

echo "--------------------------------"

if [ $fail_count -eq 0 ]; then
  echo -e "${GREEN}done! $success_count packages updated.${NC}"
else
  echo -e "${RED}summary: $success_count updated, $fail_count failed.${NC}"
  echo
  echo "details:"
  for log in "${FAILED_LOGS[@]}"; do
    echo -e "$log"
  done
  exit 1
fi
