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
    wezterm
    bitwarden
    obs-studio

    # file management
    unzip
    zip
    unar

    # GNU Utilities
    gnumake
    gcc
    cmake
    libtool
    
    # tools / services
    git
    jq
    curl
    htop
    killall
    ripgrep
    fd
    fzf
    ghq
    gh

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
