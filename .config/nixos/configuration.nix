{ config, pkgs, ... }:

let
  unstableTarball =
    fetchTarball
      https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz;
in {
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config = {
    packageOverrides = pkgs: {
      unstable = import unstableTarball {
        config = config.nixpkgs.config;
      };
    };
  };

  nix.extraOptions = ''experimental-features = nix-command flakes'';

  imports =
    [
      ./hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  networking.hostName = "dtsf-machine"; # Define your hostname.

  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.
  time.timeZone = "America/Belem";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pt_BR.UTF-8";
    LC_IDENTIFICATION = "pt_BR.UTF-8";
    LC_MEASUREMENT = "pt_BR.UTF-8";
    LC_MONETARY = "pt_BR.UTF-8";
    LC_NAME = "pt_BR.UTF-8";
    LC_NUMERIC = "pt_BR.UTF-8";
    LC_PAPER = "pt_BR.UTF-8";
    LC_TELEPHONE = "pt_BR.UTF-8";
    LC_TIME = "pt_BR.UTF-8";
  };

  console = {
    keyMap = "us";
  };

  # xserver
  services.xserver = {
    enable = true;
    layout = "us";
    displayManager.startx.enable = true;
    windowManager.bspwm.enable = true;
    windowManager.bspwm.configFile = builtins.getEnv "HOME" + "/.config/bspwm/bspwmrc";
    windowManager.bspwm.sxhkd.configFile = builtins.getEnv "HOME" + "/.config/sxhkd/sxhkdrc";
  };

  # pipewire
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # user
  programs.zsh.enable = true;
  users.users.dtsf = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [
      "wheel"
      "docker"
    ];
    packages = with pkgs; [
      discord
      spotify
      google-chrome
    ];
  };

  # system packages
  environment.systemPackages = with pkgs; [
    wget
    curl
    gcc
    gnumake
    killall
    libnotify
    neovim
    alacritty
    ranger
    mpv
    rofi
    tmux
    git
    xdg-utils
    xdg-user-dirs
    flatpak
    picom
    fd
    fzf
    zip
    unzip
    udisks2
    udiskie
    bat
    sxhkd
    polybar
    feh
    dunst
    neofetch
    trash-cli
    flameshot
    pavucontrol
    lxappearance
    unstable.eza

    xorg.xorgserver
    xorg.xf86videoamdgpu
    xorg.xf86inputevdev
    xorg.xf86inputsynaptics
    xorg.xf86inputlibinput
    xorg.fontmiscmisc
    xorg.xrandr
    xorg.xinit xorg.xrandr
    xorg.xinput
    xorg.xsetroot
  ];

  # services/daemons
  virtualisation.docker.enable = true;
  services.openssh.enable = true;
  services.udisks2.enable = true;

  # fonts
  fonts = {
    fontDir.enable = true;
    fonts = with pkgs; [
      inter
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      font-awesome
      (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    ];
    fontconfig.defaultFonts = {
      serif = [ "inter" ];
      sansSerif = [ "inter" ];
      monospace = [ "JetBrainsMono" ];
    };
  };

  environment.sessionVariables = rec {
    ZSH = "$HOME/.oh-my-zsh";
    ZSH_CUSTOM = "$HOME/.oh-my-zsh/custom";
  };

  # v.
  system.stateVersion = "23.05";
}
