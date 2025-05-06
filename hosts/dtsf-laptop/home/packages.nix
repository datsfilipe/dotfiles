{
  config,
  pkgs,
  mypkgs,
  ...
}: {
  home.packages = with pkgs; [
    qbittorrent
    slack
    beekeeper-studio
    bitwarden
    pavucontrol
  ];

  modules.desktop.nupkgs.packages = with mypkgs; [
    devtunnel-cli
    meow
  ];
}
