{pkgs, ...}: {
  home.stateVersion = "25.11";

  imports = [./packages.nix];
}
