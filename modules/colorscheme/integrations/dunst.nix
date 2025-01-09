{ colorscheme, ...}:

{
  modules.desktop.i3.dunst.settings = {
    global = {
      frame_color = colorscheme.colors.altbg;
      separator_color = colorscheme.colors.altbg;
    };

    urgency_low = {
      background = colorscheme.colors.bg;
      foreground = colorscheme.colors.primary;
      frame_color = colorscheme.colors.altbg;
    };

    urgency_normal = {
      background = colorscheme.colors.bg;
      foreground = colorscheme.colors.primary;
      frame_color = colorscheme.colors.altbg;
    };

    urgency_critical = {
      background = colorscheme.colors.red;
      foreground = colorscheme.colors.bg;
      frame_color = colorscheme.colors.red;
    };
  };
}
