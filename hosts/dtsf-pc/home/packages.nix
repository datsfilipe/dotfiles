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
    bc
  ];

  modules.desktop.nupkgs.packages = with mypkgs; [
    devtunnel-cli
    scripts
    astal
    trxsh
    meow
  ];
}
