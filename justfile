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

update target mode="update":
  nixos_build {{target}} {{mode}}

switch target mode="default":
  sudo nixos_switch {{target}} {{mode}}

upgrade target mode="update":
  nixos_switch {{target}} {{mode}}

generate-flake:
  generate_flake

edit-secrets:
  nix-shell -p sops --run "sops modules/secrets/secrets.yaml"

run-lib-tests:
  run_lib_tests
