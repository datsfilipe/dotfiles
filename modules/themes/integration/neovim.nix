{name, ...}: let
  colorschemeMap = {
    catppuccin = "catppuccin";
    min = "min";
    solarized = "solarized";
    vesper = "vesper";
    gruvbox = "gruvbox";
  };
  colorscheme = colorschemeMap.${name};
in
  colorscheme
