{pkgs, ...}: {
  home.stateVersion = "25.11";

  imports = [./packages.nix];

  modules.core.shell.fish.user.enable = true;
}
