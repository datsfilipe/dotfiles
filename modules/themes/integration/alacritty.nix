{colorscheme, ...}: {
  programs.alacritty.settings = {
    colors = {
      bright = {
        black = colorscheme.colors.black;
        red = colorscheme.colors.red;
        green = colorscheme.colors.green;
        yellow = colorscheme.colors.yellow;
        blue = colorscheme.colors.blue;
        magenta = colorscheme.colors.magenta;
        cyan = colorscheme.colors.cyan;
        white = colorscheme.colors.white;
      };
      normal = {
        black = colorscheme.colors.black;
        red = colorscheme.colors.red;
        green = colorscheme.colors.green;
        yellow = colorscheme.colors.yellow;
        blue = colorscheme.colors.blue;
        magenta = colorscheme.colors.magenta;
        cyan = colorscheme.colors.cyan;
        white = colorscheme.colors.white;
      };
      primary = {
        background = colorscheme.colors.bg;
        foreground = colorscheme.colors.fg;
      };
    };
  };
}
