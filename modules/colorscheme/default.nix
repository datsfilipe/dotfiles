{ mylib, vars, ... }:

with mylib; {
  theme = utils.match { colorscheme = vars.appearance.colorscheme or "gruvbox"; } [
    [{ colorscheme = "gruvbox"; } (import ./gruvbox.nix)]
    [{ colorscheme = "catppuccin"; } (import ./catppuccin.nix)]
    [{ colorscheme = "eva"; } (import ./eva.nix)]
    [{ colorscheme = "kanagawa"; } (import ./kanagawa.nix)]
    [{ colorscheme = "solarized"; } (import ./solarized.nix)]
    [{ colorscheme = "vesper"; } (import ./vesper.nix)]
  ];
}
