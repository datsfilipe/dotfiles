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
    claude-code
    codex
    pavucontrol
    obs-studio
    bc
    cloudflared
    pritunl-client
  ];

  modules.desktop.nupkgs.packages = with mypkgs; [
    wl-shimeji
    scripts
    astal
    focus-mode
    trxsh
  ];
}
