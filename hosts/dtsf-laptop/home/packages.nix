{
  config,
  pkgs,
  pkgs-unstable,
  mypkgs,
  lib,
  ...
}: {
  home.packages = with pkgs;
    [
      qbittorrent
      slack
      beekeeper-studio
      bitwarden
      pavucontrol
      brightnessctl
      networkmanagerapplet
    ]
    ++ [
      pkgs-unstable.zoom-us
    ];

  modules.desktop.nupkgs.packages = with mypkgs; [
    devtunnel-cli
    trxsh
    meow
  ];
}
