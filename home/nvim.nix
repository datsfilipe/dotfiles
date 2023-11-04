let
  theme = (import ../modules/colorscheme).theme;
in {
  xdg.configFile."nvim" = {
    source = ../modules/nvim;
    recursive = true;
  };

  xdg.configFile."nvim/lua/nix-colorscheme.lua".text = ''
    return "${theme.nvim-colorscheme}"
  '';
}
