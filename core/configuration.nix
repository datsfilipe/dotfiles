{ config, inputs, lib, pkgs, vars, ... }:

{
  imports =
    [ ./packages.nix ]
    ++ (import ../modules/desktops)
    ++ (import ../hosts);

  nixpkgs.config = {
    allowUnfree = true;
    chromium.enableWideVine = true;
    packageOverrides = pkgs: {
      nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
        inherit pkgs;
      };
    };
    permittedInsecurePackages = [
      "openssl-1.1.1w"
    ];
  };
  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" ];
      builders-use-substitutes = true;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    package = pkgs.nixVersions.git;
    extraOptions = ''
      keep-outputs = true
      keep-derivations = true
    '';
  };

  users.users.${vars.user} = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.fish;
    ignoreShellProgramCheck = true;
  };

  fonts = {
    fontDir.enable = true;
    packages = with pkgs; [
      inter
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      font-awesome_6
      (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    ];
    fontconfig.defaultFonts = {
      serif = [ "inter" ];
      sansSerif = [ "inter" ];
      monospace = [ "JetBrainsMono" ];
    };
  };

  system.stateVersion = "24.05";
}
