{colorscheme, ...}: {
  xdg.configFile."wezterm/theme.lua".text = ''
    return {
      background = "${colorscheme.colors.bg}",
      foreground = "${colorscheme.colors.fg}",
      cursor_bg = "${colorscheme.colors.fg}",
      cursor_fg = "${colorscheme.colors.selection}",
      cursor_border = "${colorscheme.colors.fg}",
      selection_fg = "${colorscheme.colors.selection}",
      selection_bg = "${colorscheme.colors.fg}",
      scrollbar_thumb = "${colorscheme.colors.fg}",
      split = "${colorscheme.colors.white}",
      ansi = {
        "${colorscheme.colors.bg}",
        "${colorscheme.colors.red}",
        "${colorscheme.colors.green}",
        "${colorscheme.colors.yellow}",
        "${colorscheme.colors.blue}",
        "${colorscheme.colors.magenta}",
        "${colorscheme.colors.cyan}",
        "${colorscheme.colors.fg}",
      },
      brights = {
        "${colorscheme.colors.white}",
        "${colorscheme.colors.red}",
        "${colorscheme.colors.green}",
        "${colorscheme.colors.yellow}",
        "${colorscheme.colors.blue}",
        "${colorscheme.colors.magenta}",
        "${colorscheme.colors.cyan}",
        "${colorscheme.colors.bg}",
      },
    }
  '';
}
