{ config, lib, pkgs, ... }:

{
  imports = (
    import ../modules/desktops
  );
  nixpkgs.config.allowUnfree = true;
  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    package = pkgs.nixVersions.unstable;
  };


  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  networking.hostName = "dtsf-machine";

  time.timeZone = "America/Belem";

  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "us";

  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  users.users.dtsf = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  };

  environment.systemPackages = with pkgs; [
    xdg-utils
    xdg-user-dirs
    gnumake
    gcc
    curl
    zsh
    git
    dunst
    gtk3
    gtk-layer-shell
  ];

  services.openssh.enable = true;

  programs.neovim = {
    enable = true;
    vimAlias = true;
  };

  fonts = {
    fontDir.enable = true;
    packages = with pkgs; [
      inter
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    ];
    fontconfig.defaultFonts = {
      serif = [ "inter" ];
      sansSerif = [ "inter" ];
      monospace = [ "JetBrainsMono" ];
    };
  };

  nix.settings = {
    builders-use-substitutes = true;
    # substituters to use
    substituters = [
        "https://anyrun.cachix.org"
    ];

    trusted-public-keys = [
        "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
    ];
  };

  environment.etc."xdg/user-dirs.defaults".text = ''
    DESKTOP=system/desktop
    DOWNLOAD=downloads
    TEMPLATES=system/templates
    PUBLICSHARE=system/public
    DOCUMENTS=documents
    MUSIC=media/music
    PICTURES=media/photos
    VIDEOS=media/video
  '';

  programs.steam.enable = true;

  system.stateVersion = "23.11"; # Did you read the comment?
}
