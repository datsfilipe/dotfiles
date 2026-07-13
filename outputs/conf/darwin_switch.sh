main() {
  local target=".#$1"
  local mode="$2"
  if [ "$mode" = "debug" ]; then
    darwin-rebuild switch --flake "$target" --show-trace --verbose
  elif [ "$mode" = "update" ]; then
    nix flake update
    darwin-rebuild switch --flake "$target"
  else
    nix flake update datsnvim
    nix flake update unix-scripts
    darwin-rebuild switch --flake "$target"
  fi
}

main "$@"
