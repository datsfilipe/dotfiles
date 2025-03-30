{colorscheme, ...}: {
  programs.rio.settings = {
    colors.background = "${colorscheme.colors.bg}";
    colors.black = "${colorscheme.colors.black}";
    colors.blue = "${colorscheme.colors.blue}";
    colors.cyan = "${colorscheme.colors.cyan}";
    colors.foreground = "${colorscheme.colors.fg}";
    colors.green = "${colorscheme.colors.green}";
    colors.magenta = "${colorscheme.colors.magenta}";
    colors.red = "${colorscheme.colors.red}";
    colors.white = "${colorscheme.colors.white}";
    colors.yellow = "${colorscheme.colors.yellow}";

    colors.cursor = "${colorscheme.colors.primary}";
    colors.vi-cursor = "${colorscheme.colors.fg}";

    # Navigation
    colors.tabs = "${colorscheme.colors.bg}";
    colors.tabs-foreground = "${colorscheme.colors.fg}";
    colors.tabs-active = "${colorscheme.colors.bg}";
    colors.tabs-active-highlight = "${colorscheme.colors.green}";
    colors.tabs-active-foreground = "${colorscheme.colors.fg}";
    colors.bar = "${colorscheme.colors.bg}";

    colors.search-match-background = "${colorscheme.colors.fg}";
    colors.search-match-foreground = "${colorscheme.colors.bg}";
    colors.search-focused-match-background = "${colorscheme.colors.yellow}";
    colors.search-focused-match-foreground = "${colorscheme.colors.bg}";

    colors.selection-foreground = "${colorscheme.colors.bg}";
    colors.selection-background = "${colorscheme.colors.primary}";

    colors.dim-black = "${colorscheme.colors.black}";
    colors.dim-blue = "${colorscheme.colors.blue}";
    colors.dim-cyan = "${colorscheme.colors.cyan}";
    colors.dim-foreground = "${colorscheme.colors.fg}";
    colors.dim-green = "${colorscheme.colors.green}";
    colors.dim-magenta = "${colorscheme.colors.magenta}";
    colors.dim-red = "${colorscheme.colors.red}";
    colors.dim-white = "${colorscheme.colors.white}";
    colors.dim-yellow = "${colorscheme.colors.yellow}";

    colors.light-black = "${colorscheme.colors.black}";
    colors.light-blue = "${colorscheme.colors.blue}";
    colors.light-cyan = "${colorscheme.colors.cyan}";
    colors.light-foreground = "${colorscheme.colors.fg}";
    colors.light-green = "${colorscheme.colors.green}";
    colors.light-magenta = "${colorscheme.colors.magenta}";
    colors.light-red = "${colorscheme.colors.red}";
    colors.light-white = "${colorscheme.colors.white}";
    colors.light-yellow = "${colorscheme.colors.yellow}";
  };
}
