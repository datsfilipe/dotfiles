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
      bitwarden-desktop
      pavucontrol
    ]
    ++ [
      pkgs-unstable.zoom-us
    ];

  modules.desktop.nupkgs.packages = with mypkgs; [
    devtunnel-cli
    scripts
    trxsh
    meow
  ];
}
