#!/bin/sh

USER=$(whoami)

# setup unix-scripts for user
rm -rf /home/$USER/.local/bin
mkdir /home/$USER/.local/bin
ln ./dotfiles/bin/* /home/$USER/.local/bin

# backup buku database
buku -l 8
cp /home/$USER/.local/share/buku/bookmarks.db.enc ./dotfiles/buku/bookmarks.db.enc

sudo nixos-rebuild switch --flake .?submodules=1#$USER-machine --impure
