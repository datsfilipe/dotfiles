{
  colorscheme,
  mylib,
  ...
}: {
  home.file.".local/share/astal/variables.scss".source = builtins.toFile "variables.scss" ''
    $primary: ${colorscheme.colors.primary};
    $bg: ${(mylib.color.darkenHex colorscheme.colors.bg 0.8)};
    $altbg: ${colorscheme.colors.altbg};
    $fg: ${colorscheme.colors.fg};
    $black: ${colorscheme.colors.black};
    $red: ${colorscheme.colors.red};
    $green: ${colorscheme.colors.green};
    $yellow: ${colorscheme.colors.yellow};
    $blue: ${colorscheme.colors.blue};
    $magenta: ${colorscheme.colors.magenta};
    $cyan: ${colorscheme.colors.cyan};
    $white: ${colorscheme.colors.white};
  '';
}
