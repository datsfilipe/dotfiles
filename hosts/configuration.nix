{ config, inputs, lib, pkgs, vars, ... }:

{
  imports =
    [ ./dtsf-machine ./packages.nix ]
    ++ (import ../modules/desktops );

  nixpkgs.config = {
    allowUnfree = true;
    packageOverrides = pkgs: {
      nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
        inherit pkgs;
      };
    };
  };
  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" ];
      builders-use-substitutes = true;
      substituters = [
        "https://anyrun.cachix.org"
      ];
      trusted-public-keys = [
        "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
      ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    package = pkgs.nixVersions.unstable;
    extraOptions = ''
      keep-outputs = true
      keep-derivations = true
    '';
  };

  users.users.dtsf = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
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

  system.stateVersion = "23.11";
}
