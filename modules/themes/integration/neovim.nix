{name, ...}: let
  colorschemeMap = {
    catppuccin = "catppuccin";
    min = "min";
    solarized = "solarized";
    vesper = "vesper";
    carbon = "carbon";
    gruvbox = "gruvbox";
  };
  colorscheme = colorschemeMap.${name};
in
  colorscheme
