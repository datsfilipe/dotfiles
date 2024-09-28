#!/bin/sh

git_root=$(git rev-parse --show-toplevel)

if [ "$PWD" != "$git_root" ]; then
  echo "please run this script from the root of the git repo"
  exit 1
fi

nix flake update datsnvim
nix flake update unix-scripts

if [ -z "$1" ]; then
  echo "please specify a host to switch to"
  exit 1
fi

case "$2" in
  '--debug')
    sudo nixos-rebuild switch --impure --flake .\#$1 --show-trace -L -v
  ;;
  *)
    sudo nixos-rebuild switch --impure --flake .\#$1
  ;;
esac

if [ -d "$HOME/.config/ags" ]; then
  ags_root="$HOME/.config/ags"
  pushd $ags_root || exit 1

  if [ ! -d "$ags_root/node_modules" ]; then
    direnv exec "$HOME/.config/ags" pnpm i
  fi

  popd || exit 1
fi

bat cache --build

