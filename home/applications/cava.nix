{ theme, ... }:

{
  programs.cava = {
    enable = true;
    settings = {
      general.framerate = 60;
      smoothing.noise-reduction = 88;
      color = {
        background = theme.scheme.colors.bg;
        foreground = theme.scheme.colors.fg;
      };
    };
  };
}
