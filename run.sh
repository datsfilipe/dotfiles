#!/bin/sh

sudo nixos-rebuild switch --impure --flake .#dtsf-machine
