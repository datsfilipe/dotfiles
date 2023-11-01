{ inputs, pkgs, ... }:
{
  home.packages = with pkgs; [
    # gui
    mpv
    qbittorrent
    discord
    wezterm
    inputs.ags.packages.${pkgs.system}.default
    inputs.anyrun.packages.${system}.anyrun

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
