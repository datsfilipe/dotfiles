{
  config,
  pkgs,
  pkgs-unstable,
  mypkgs,
  lib,
  ...
}: let
  krita-wayland = pkgs.writeShellScriptBin "krita" ''
    unset DESKTOP_SESSION
    unset XDG_SESSION_DESKTOP
    unset XDG_CURRENT_DESKTOP
    unset GDMSESSION
    export KRITA_FORCE_WAYLAND=1
    export KRITA_USE_NATIVE_CANVAS_SURFACE=1
    export QT_QPA_PLATFORM=wayland
    exec ${pkgs.krita}/bin/krita "$@"
  '';
in {
  home.packages = with pkgs; [
    bc
    mesa
    slack
    bitwarden-desktop
    pavucontrol
    brightnessctl
    krita-wayland
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
