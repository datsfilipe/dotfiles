#!/bin/sh

git_root=$(git rev-parse --show-toplevel)

if [ "$PWD" != "$git_root" ]; then
  echo "please run this script from the root of the git repo"
  exit 1
fi

# update config submodules
nix flake update datsnvim
nix flake update unix-scripts
nix flake update walls

sudo nixos-rebuild switch --impure --flake .#dtsf-machine

# update ags dependencies
ags_root="$HOME/.config/ags"
pushd $ags_root || exit 1

if [ ! -d "$ags_root/node_modules" ]; then
  direnv exec "$HOME/.config/ags" pnpm i
fi

# remove spaceship prompt file
# rm "$HOME/.config/spaceship.zsh.zwc"

# rebuild bat cache
# bat cache --build

popd || exit 1
