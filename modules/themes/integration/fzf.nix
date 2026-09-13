{colorscheme, ...}: {
  programs.fzf.colors = {
    "bg+" = "-1";
    bg = "-1";
    spinner = colorscheme.colors.yellow;
    hl = colorscheme.colors.primary;
    fg = colorscheme.colors.fg;
    header = colorscheme.colors.primary;
    info = colorscheme.colors.magenta;
    pointer = colorscheme.colors.yellow;
    marker = colorscheme.colors.yellow;
    "fg+" = colorscheme.colors.fg;
    prompt = colorscheme.colors.magenta;
    "hl+" = colorscheme.colors.primary;
  };
  programs.fzf.enable = true;
}
