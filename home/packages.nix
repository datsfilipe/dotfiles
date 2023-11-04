{ inputs, pkgs, ... }:
{
  home.packages = with pkgs; [
    inputs.ags.packages.${pkgs.system}.default
    inputs.anyrun.packages.${system}.anyrun
    qbittorrent
    pavucontrol
    discord
    wezterm
    google-chrome
    bitwarden
    mpv
    bat
    eza
    zoxide
    fzf
    trash-cli
    fd
    inotify-tools
    libnotify
    ffmpeg
    killall
    zip
    unzip
    unar
  ];
}
