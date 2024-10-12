{ pkgs, customPkgs ? pkgs.lib.mkDefault [] }:

with pkgs; {
  environment.systemPackages = [
    # system
    util-linux
    xdg-utils
    xdg-user-dirs
    gtk-layer-shell
    gtk3

    # apps
    beekeeper-studio
    qbittorrent
    fastfetch
    bitwarden
    zoom-us
    slack
    krita

    # utilities
    git
    jq
    curl
    ripgrep
    fd
    fzf
    ghq
    gh
    gnumake
    gcc
    cmake
    libtool
    lsof
    killall
    brightnessctl
    blueberry

    # services
    udiskie
    libnotify
    inotify-tools

    # media
    pavucontrol
    ffmpeg
  ] ++ customPkgs;
}
