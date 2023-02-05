#!/bin/sh

a=$(pacman -Qu | wc -l);

if [[ "$a" -ne "0" ]]; then 
  printf "󰚰";
fi
