{
  config,
  pkgs,
  mypkgs,
  lib,
  ...
}: {
  imports = [./packages.nix];

  modules.desktop.colorscheme.theme = "gruvbox";

  programs.ssh = {
    enable = true;
    extraConfig = ''
      Host github.com
      IdentityFile ~/.ssh/main_key
      IdentitiesOnly yes
      AddKeysToAgent yes
    '';
  };
}
