{ pkgs, ... }:

let
  localPkgs = import ../pkgs { pkgs = pkgs; };
  customPkgs = with localPkgs; [];
in {
  services.openssh.enable = true;
  services.udisks2.enable = true;

  programs.neovim = {
    enable = true;
    vimAlias = true;
  };

  programs.steam.enable = true;

  environment.systemPackages = with pkgs; [
    # system
    xdg-utils
    xdg-user-dirs
    gtk-layer-shell
    gtk3

    # apps
    qbittorrent
    discord
    alacritty
    bitwarden
    obs-studio
    # zoom-us

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
    efibootmgr
    unzip
    zip
    unar

    # services
    udiskie
    libnotify
    inotify-tools
    
    # media
    pavucontrol
    mpv
    ffmpeg
  ] ++ customPkgs;
}
