{ inputs, pkgs, ... }:

let
  theme = (import ../../modules/colorscheme).theme;
in {
  xdg.configFile."nvim" = {
    source = inputs.datsnvim;
    recursive = true;
  };

  xdg.configFile."nvim/lua/utils/nix_colorscheme.lua".text = ''
    return "${theme.nvim-colorscheme}"
  '';

  xdg.configFile."nvim/lua/utils/nix_lazylock.lua".text = ''
    return vim.fn.expand("$HOME/.dotfiles/dotfiles/nvim") .. "/lazy-lock.json"
  '';

  home.packages = with pkgs; [
    nodejs # copilot needs it
  ];
}
