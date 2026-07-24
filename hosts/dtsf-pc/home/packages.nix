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
    # bitwarden-desktop
    claude-code
    pavucontrol
    obs-studio
    zoom-us
    bc
  ];

  modules.desktop.nupkgs.packages = with mypkgs; [
    devtunnel-cli
    wl-shimeji
    scripts
    astal
    focus-mode
    trxsh
  ];
}
