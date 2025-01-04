default:
  @just --list

history:
  nix profile history --profile /nix/var/nix/profiles/system

wipe-history:
  sudo nix profile wipe-history --profile /nix/var/nix/profiles/system  --older-than 7d

gc:
  sudo nix-collect-garbage --delete-older-than 7d
  nix-collect-garbage --delete-older-than 7d

verify-store:
  nix store verify --all

build target mode="default":
  nixos_build {{target}} {{mode}}

switch target mode="default":
  sudo nixos_switch {{target}} {{mode}}

upgrade target mode="update":
  sudo nix-channel --update
  nixos_switch {{target}} {{mode}}

generate-flake:
  generate_flake
