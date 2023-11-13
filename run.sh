#!/bin/sh

USER="dtsf"

rm -rf /home/$USER/.local/bin
ln -s ./modules/scripts /home/$USER/.local/bin

nixos-rebuild switch --flake .?submodules=1#$USER-machine
