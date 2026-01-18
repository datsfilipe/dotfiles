default:
  @just --list

history:
  nix profile history --profile /nix/var/nix/profiles/system

wipe-history:
  sudo nix profile wipe-history --profile /nix/var/nix/profiles/system  --older-than 7d

gc:
  sudo nix-collect-garbage --delete-older-than 7d
  nix-collect-garbage --delete-older-than 7d

verify:
  nix store verify --all

fmt:
  alejandra .
  find . -type f -name "*.kdl" -exec kdlfmt format {} +

build target mode="default":
  nixos_build {{target}} {{mode}}

switch target mode="default":
  sudo nixos_switch {{target}} {{mode}}

update target mode="update":
  sudo nixos_switch {{target}} {{mode}}

generate:
  generate_flake

secrets:
  nix-shell -p sops --run "sops modules/secrets/secrets.yaml"

test:
  run_lib_tests
