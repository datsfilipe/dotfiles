{
  config,
  pkgs,
  pkgs-unstable,
  mypkgs,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    qbittorrent
    slack
    bitwarden-desktop
    pavucontrol
    brightnessctl
    networkmanagerapplet
  ];

  modules.desktop.nupkgs.packages = with mypkgs; [
    devtunnel-cli
    scripts
    trxsh
    meow
  ];
}
