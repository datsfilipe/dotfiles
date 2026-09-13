#!/usr/bin/env bash
set -euo pipefail

source "$(git rev-parse --show-toplevel)/scripts/lib/update-source.sh"
SCRIPT_DIR=$(script_dir)
TAG=$(github_latest_tag dani-garcia/vaultwarden)

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
