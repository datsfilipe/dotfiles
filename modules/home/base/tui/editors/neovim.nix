{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  lockfile = "${config.home.homeDirectory}/.dotfiles/modules/home/base/tui/editors/conf/lazy-lock.json";
in {
  home.packages = with pkgs; [
    tree-sitter
    fd
  ];

  programs.datsnvim.enable = true;
}
