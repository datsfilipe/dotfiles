{...}: {
  imports = [./packages.nix];

  programs.ssh = {
    enable = true;
    extraConfig = ''
      Host github.com
      IdentityFile ~/.ssh/main_key
      IdentitiesOnly yes
      AddKeysToAgent yes
    '';
  };

  modules.desktop.colorscheme.theme = "gruvbox";
}
