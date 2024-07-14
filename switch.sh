#!/bin/sh

git_root=$(git rev-parse --show-toplevel)

if [ "$PWD" != "$git_root" ]; then
  echo "please run this script from the root of the git repo"
  exit 1
fi

nix flake update datsnvim
nix flake update unix-scripts
nix flake update walls

case "$1" in
  '--debug')
    sudo nixos-rebuild switch --impure --flake .#dtsf-machine --show-trace -L -v
  ;;
  *)
    sudo nixos-rebuild switch --impure --flake .#dtsf-machine
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

