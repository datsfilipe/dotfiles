{
  config,
  pkgs,
  mypkgs,
  ...
}: {
  home.packages = with pkgs; [
    qbittorrent
    zoom-us
    slack
    beekeeper-studio
    bitwarden
    pavucontrol
  ];

  modules.desktop.nupkgs.packages = with mypkgs; [
    devtunnel-cli
    linux-shimeji
  ];
}
