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
    bc
  ];

  modules.desktop.nupkgs.packages = with mypkgs; [
    nix-envs
    meow
    trxsh
  ];
}
