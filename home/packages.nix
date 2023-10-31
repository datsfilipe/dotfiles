{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # gui
    mpv
    spotify
    qbittorrent
    discord
    wezterm

    # tools
    bat
    eza
    zoxide
    fd
    ripgrep
    fzf
    inotify-tools
    ffmpeg
    libnotify
    killall
    zip
    unzip
    flameshot

    # hyprland
    wl-clipboard
    pavucontrol
  ];
}
