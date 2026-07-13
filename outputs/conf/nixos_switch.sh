main() {
  local target=".#$1"
  local mode="$2"
  if [ "$mode" = "debug" ]; then
    nixos-rebuild switch --flake "$target" --show-trace --verbose
  elif [ "$mode" = "update" ]; then
    nix flake update
    nixos-rebuild switch --flake "$target"
  else
    nix flake update datsnvim
    nix flake update unix-scripts
    nixos-rebuild switch --flake "$target"
  fi

  if [ -d /boot/EFI/refind ]; then
    cp /boot/EFI/refind/refind.conf /boot/EFI/BOOT/refind.conf
    cp -r /boot/EFI/refind/themes /boot/EFI/BOOT/ 2>/dev/null || true
  fi
}

main "$@"
