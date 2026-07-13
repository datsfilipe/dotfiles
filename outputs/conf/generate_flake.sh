main() {
  if [ -f flake.nix ]; then
    if ! command -v trash &>/dev/null; then
      rm flake.nix
    else
      trash flake.nix
    fi
  fi
  nix eval --raw -f templates/flake.template.nix flake >flake.nix
  alejandra flake.nix
}

main "$@"
