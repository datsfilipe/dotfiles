{
  pkgs,
  mypkgs,
  ...
}: {
  home.packages = with pkgs; [
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
}
