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
    obs-studio
    bc
  ];

  modules.desktop.nupkgs.packages = with mypkgs; [
    devtunnel-cli
    wl-shimeji
    scripts
    astal
    trxsh
    meow
  ];
}
