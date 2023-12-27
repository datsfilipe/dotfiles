{ pkgs, ... }:

{
  services.openssh.enable = true;

  programs.neovim = {
    enable = true;
    vimAlias = true;
  };

  programs.steam.enable = true;

  environment.systemPackages = with pkgs; [
    # apps
    qbittorrent
    discord
    alacritty
    bitwarden
    obs-studio

    # file management
    unzip
    zip
    unar

    # utilities
    gnumake
    gcc
    cmake
    libtool
    lsof
    killall
    efibootmgr
    
    # tools
    git
    jq
    curl
    htop
    ripgrep
    fd
    fzf
    ghq
    gh
    buku

    # services / daemons
    dunst
    libnotify
    inotify-tools
    
    # media
    pavucontrol
    mpv
    ffmpeg

    # system
    nodejs
    xdg-utils
    xdg-user-dirs
    gtk-layer-shell
    gtk3
  ];
}
