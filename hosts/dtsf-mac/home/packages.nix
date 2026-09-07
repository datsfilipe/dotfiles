{
  config,
  pkgs,
  pkgs-unstable,
  mypkgs,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    claude-code
    codex
    bc
  ];

  programs.neovim.package = lib.mkForce pkgs.neovim-unwrapped;

  modules.desktop.nupkgs.packages = with mypkgs; [
    trxsh
    scripts
  ];
}
