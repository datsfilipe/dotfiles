default:
  @just --list

upgrade:
  sudo nix-channel --update
  sudo nix flake update

history:
  nix profile history --profile /nix/var/nix/profiles/system

wipe-history:
  sudo nix profile wipe-history --profile /nix/var/nix/profiles/system  --older-than 7d

gc:
  sudo nix-collect-garbage --delete-older-than 7d
  nix-collect-garbage --delete-older-than 7d

shell:
  nix shell nixpkgs#git nixpkgs#just

verify-store:
  nix store verify --all

build target mode="default":
  nixos_build {{target}} {{mode}}

switch target mode="default":
  nixos_switch {{target}} {{mode}}
