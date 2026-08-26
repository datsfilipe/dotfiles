#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

TAG=$(curl -fsSL https://api.github.com/repos/dani-garcia/vaultwarden/releases/latest | grep '"tag_name"' | head -n1 | cut -d'"' -f4)

SRC_HASH=$(nix run nixpkgs#nix-prefetch-github -- dani-garcia vaultwarden --rev "$TAG" | nix run nixpkgs#jq -- -r .hash)

CARGO_HASH=$(nix build --no-link --impure --expr "
  let
    pkgs = import <nixpkgs> {};
    src = pkgs.fetchFromGitHub {
      owner = \"dani-garcia\";
      repo = \"vaultwarden\";
      tag = \"${TAG}\";
      hash = \"${SRC_HASH}\";
    };
  in
    pkgs.rustPlatform.fetchCargoVendor { inherit src; hash = pkgs.lib.fakeHash; }
" 2>&1 | grep -oP 'got:\s*\K\S+')

cat >"$SCRIPT_DIR/source.json" <<EOF
{
  "version": "${TAG}",
  "srcHash": "${SRC_HASH}",
  "cargoHash": "${CARGO_HASH}"
}
EOF

echo "updated vaultwarden source.json to ${TAG}"
