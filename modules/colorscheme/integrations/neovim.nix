{ mylib, name, ...}:

with mylib; match { colorscheme = name; } [
  [{ colorscheme = "gruvbox"; } "gruvbox"]
  [{ colorscheme = "min"; } "min-theme"]
  [{ colorscheme = "solarized"; } "solarized-osaka"]
  [{ colorscheme = "vesper"; } "vesper"]
  [{ colorscheme = "catppuccin"; } "catppuccin"]
  [{ colorscheme = "kanagawa"; } "kanagawa"]
]
