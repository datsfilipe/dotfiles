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
    cloudflared
    mesa
    rnote
    pavucontrol
    brightnessctl
    krita-xcb
    gnome-tweaks
    gnome-extension-manager
    gnomeExtensions.dash-to-dock
    gnomeExtensions.appindicator
    gnomeExtensions.keyboard-toggle
  ];

  modules.desktop.nupkgs.packages = with mypkgs; [
    scripts
    trxsh
  ];

  xdg.configFile."kritarc".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/hosts/dtsf-laptop/home/krita/kritarc";

  xdg.configFile."kritashortcutsrc".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/hosts/dtsf-laptop/home/krita/kritashortcutsrc";

  xdg.dataFile."krita".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/hosts/dtsf-laptop/home/krita/data";
}
