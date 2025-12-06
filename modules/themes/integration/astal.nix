{colorscheme, ...}: {
  home.file.".local/share/astal/variables.scss".source = builtins.toFile "variables.scss" ''
    $primary: ${colorscheme.colors.primary};
    $fg: ${colorscheme.colors.fg};
    $bg: ${colorscheme.colors.bg};
    $altbg: ${colorscheme.colors.altbg};
    $selection: ${colorscheme.colors.selection};
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
