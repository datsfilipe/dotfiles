{ inputs, vars, ... }:

{
  xdg.configFile."wallpaper.png".source = "${inputs.walls}/${vars.appearance.wall}";
}
