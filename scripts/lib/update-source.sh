#!/usr/bin/env bash

script_dir() {
  cd "$(dirname "${BASH_SOURCE[1]}")" && pwd
}

github_latest_tag() {
  curl -fsSL "https://api.github.com/repos/$1/releases/latest" | jq -r .tag_name
}

to_sri() {
  nix hash convert --hash-algo sha256 --to sri "$1"
}
