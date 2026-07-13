while IFS=, read -r path age; do
  if [ -d "$path" ]; then
    find "$path" -type f -mtime +"${age%d}" -delete 2>/dev/null
  fi
done <@configFile@

find "@homeDir@" -type d \( -name ".trash" -o -name ".Trash" -o -name ".Trash-1000" -o -name "Trash" \) -prune -exec rm -rf {} + 2>/dev/null || true
