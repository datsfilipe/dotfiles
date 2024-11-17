#!/usr/bin/env bash

sudo nix-channel --update
sudo nix flake update
./switch.sh $1
