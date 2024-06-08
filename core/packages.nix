{ pkgs, ... }:

let
  localPkgs = import ../pkgs { pkgs = pkgs; };
  customPkgs = with localPkgs; [
    devtunnel
    fetch
  ];
in {
  services.openssh.enable = true;
  services.udisks2.enable = true;

  environment.systemPackages = with pkgs; [
    # system
    xdg-utils
    xdg-user-dirs
    gtk-layer-shell
    gtk3

    # apps
    qbittorrent
    bitwarden
    obs-studio
    slack
    zoom-us
    beekeeper-studio

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
