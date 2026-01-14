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
    export QT_QPA_PLATFORM=wayland
    export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
    export QT_AUTO_SCREEN_SCALE_FACTOR=1
    export QT_SCALE_FACTOR=1.25
    export QT_SCALE_FACTOR_ROUNDING_POLICY=RoundPreferFloor
    exec ${pkgs.krita}/bin/krita "$@"
  '';
in {
  home.packages = with pkgs; [
    slack
    bitwarden-desktop
    pavucontrol
    brightnessctl
    bc
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
