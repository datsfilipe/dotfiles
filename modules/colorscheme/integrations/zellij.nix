{
  config,
  lib,
  colorscheme,
  ...
}: let
  zellijConf = config.xdg.configFile."zellij/zellij.toml".text or null;
in {
  modules.desktop.conf.zellij = {
    theme = "custom";
    themeConfig = {
      bg = colorscheme.colors.bg;
      black = colorscheme.colors.bg;
      blue = colorscheme.colors.blue;
      cyan = colorscheme.colors.cyan;
      fg = colorscheme.colors.fg;
      green = colorscheme.colors.black;
      magenta = colorscheme.colors.magenta;
      orange = colorscheme.colors.green;
      red = colorscheme.colors.red;
      white = colorscheme.colors.white;
      yellow = colorscheme.colors.yellow;
    };
  };
}
