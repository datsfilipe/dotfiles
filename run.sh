#!/bin/sh

USER=$(whoami)

# setup unix-scripts for user
rm -rf /home/$USER/.local/bin
mkdir /home/$USER/.local/bin
ln ./modules/scripts/* /home/$USER/.local/bin

sudo nixos-rebuild switch --flake .?submodules=1#$USER-machine
