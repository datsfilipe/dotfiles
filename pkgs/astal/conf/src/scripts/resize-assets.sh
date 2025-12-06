#!/usr/bin/env nix-shell
#!nix-shell -i bash -p imagemagick

set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
ASSETS_DIR="$SCRIPT_DIR/../assets"
TARGET_SIZE="40x40"

if [ ! -d "$ASSETS_DIR" ]; then
  echo "rrror: $ASSETS_DIR not found."
  echo "resolved path: $ASSETS_DIR"
  exit 1
fi

echo "resizing GIFs in $ASSETS_DIR to $TARGET_SIZE..."

for file in "$ASSETS_DIR"/*.gif; do
  if [ -f "$file" ]; then
    echo "processing: $file"
    magick "$file" -coalesce -resize "$TARGET_SIZE" -layers Optimize "$file"
  fi
done

echo "done."
