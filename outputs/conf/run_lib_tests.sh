main() {
  pushd "$DOTFILES_ROOT" || exit 1
  nix-shell -p nix-unit --run "nix-unit ./lib/spec.nix --gc-roots-dir ./.result-test"
  popd || exit 1
}

main "$@"
