#!/usr/bin/env bash
set -euo pipefail

if [ $# -ne 1 ]; then
  echo "usage: $0 <path>"
  exit 1
fi

BASE_PATH=$(realpath "$1")

process_updates() {
  local total_found=0
  local total_run=0
  local total_failed=0
  local failed_scripts=()

  while IFS= read -r script || [ -n "$script" ]; do
    total_found=$((total_found + 1))
    echo "running update script: $script"
    
    dir_name=$(basename "$(dirname "$script")")
    
    if [ "$dir_name" = "conf" ]; then
      script=$(realpath "$script")
      if bash "$script"; then
        echo "successfully ran $script"
        total_run=$((total_run + 1))
      else
        echo "failed to run $script"
        total_failed=$((total_failed + 1))
        failed_scripts+=("$script")
      fi
    else
      echo "skipping $script as it's not in a 'conf' directory"
    fi
  done < <(find "$BASE_PATH" -mindepth 3 -maxdepth 3 -name "update.sh" -type f)

  echo
  echo "update Summary:"
  echo "---------------"
  echo "total update scripts found: $total_found"
  echo "total scripts run: $total_run"
  echo "total scripts failed: $total_failed"
  
  if [ ${#failed_scripts[@]} -gt 0 ]; then
    echo
    echo "failed scripts:"
    printf '%s\n' "${failed_scripts[@]}"
    return 1
  fi

  return 0
}

if [ ! -d "$BASE_PATH" ]; then
  echo "error: provided path '$BASE_PATH' is not a directory"
  exit 1
fi

echo "scanning for update scripts in: $BASE_PATH"
process_updates
