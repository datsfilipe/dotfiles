{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # gui
    mpv
    spotify
    qbittorrent
    discord

    # tools
    bat
    eza
    fd
    ripgrep
    fzf
    inotify-tools
    ffmpeg
    libnotify
    killall
    zip
    unzip
    wezterm

    # hyprland
    wl-clipboard
    pavucontrol
  ];
}
