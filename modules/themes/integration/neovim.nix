{name, ...}: let
  colorschemeMap = {
    catppuccin = "catppuccin";
    kanagawa = "kanagawa";
    min = "min-theme";
    solarized = "solarized-osaka";
    vesper = "vesper";
    gruvbox = "gruvbox";
  };
  colorscheme = colorschemeMap.${name};
in
  colorscheme
