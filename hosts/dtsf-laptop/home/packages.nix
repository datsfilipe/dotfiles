{
  config,
  pkgs,
  pkgs-unstable,
  mypkgs,
  lib,
  ...
}: let
  krita-xcb = pkgs.writeShellScriptBin "krita" ''
    export QT_QPA_PLATFORM=xcb
    exec ${pkgs.krita}/bin/krita "$@"
  '';
in {
  home.packages = with pkgs; [
    bc
    mesa
    slack
    # bitwarden-desktop
    pavucontrol
    brightnessctl
    krita-xcb
    gnome-tweaks
    gnome-extension-manager
    gnomeExtensions.dash-to-dock
    gnomeExtensions.appindicator
  ];

  modules.desktop.nupkgs.packages = with mypkgs; [
    devtunnel-cli
    nix-envs
    scripts
  ];
}
