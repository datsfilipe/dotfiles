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
    qbittorrent
    slack
    zoom-us
    beekeeper-studio
    steam
    prismlauncher
    fastfetch
    bitwarden

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

    # services
    udiskie
    libnotify
    inotify-tools

    # media
    pavucontrol
    ffmpeg
  ] ++ customPkgs;
}
