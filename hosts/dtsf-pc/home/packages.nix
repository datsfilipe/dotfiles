{
  config,
  pkgs,
  pkgs-unstable,
  mypkgs,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    krita
    qbittorrent
    claude-code
    codex
    pavucontrol
    obs-studio
    bc
    cloudflared
    pritunl-client
  ];

  modules.desktop.nupkgs.packages = with mypkgs; [
    wl-shimeji
    scripts
    quickshell
    focus-mode
    trxsh
  ];

  xdg.configFile."kritarc".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/hosts/dtsf-pc/home/krita/kritarc";

  xdg.configFile."kritashortcutsrc".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/hosts/dtsf-pc/home/krita/kritashortcutsrc";

  xdg.dataFile."krita".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/pkgs/krita-resources/data";
}
