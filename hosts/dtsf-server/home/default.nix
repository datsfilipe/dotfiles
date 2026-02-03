{pkgs, ...}: {
  home.stateVersion = "25.11";

  imports = [
    ./packages.nix
    ../../../modules/programs/git/user.nix
  ];

  modules.core.shell.fish.user.enable = true;
  modules.programs.git.enable = true;
}
