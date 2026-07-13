main() {
  local target=".#$1"
  local mode="$2"
  if [ "$mode" = "debug" ]; then
    nixos-rebuild build --flake "$target" --show-trace --verbose
  elif [ "$mode" = "update" ]; then
    pushd "$DOTFILES_ROOT"
    ./scripts/update-nupkgs.sh ./pkgs
    nix flake update
    nixos-rebuild build --flake "$target"
    popd || exit 1
  else
    nixos-rebuild build --flake "$target"
  fi
}

main "$@"
