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
    claude-code
    pavucontrol
    obs-studio
    zoom-us
    bc
    pritunl-client
  ];

  modules.desktop.nupkgs.packages = with mypkgs; [
    devtunnel-cli
    wl-shimeji
    nix-envs
    scripts
    astal
    trxsh
    meow
  ];
}
