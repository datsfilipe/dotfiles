#!/bin/sh

# update config submodules
nix flake update datsnvim
nix flake update unix-scripts
nix flake update walls

sudo nixos-rebuild switch --impure --flake .#dtsf-machine
