{
  config,
  pkgs,
  mypkgs,
  lib,
  ...
}: {
  imports = [./packages.nix];

  home.packages = with pkgs;
    [
      qbittorrent
      slack
      beekeeper-studio
      bitwarden
      pavucontrol
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
