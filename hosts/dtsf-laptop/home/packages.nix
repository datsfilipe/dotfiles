{
  config,
  pkgs,
  pkgs-unstable,
  mypkgs,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    slack
    bitwarden-desktop
    pavucontrol
    brightnessctl
    networkmanagerapplet
    bc
  ];

  modules.desktop.nupkgs.packages = with mypkgs; [
    devtunnel-cli
    nix-envs
    scripts
    astal
    trxsh
    meow
  ];
}
