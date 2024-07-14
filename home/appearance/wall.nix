{ vars, ... }:

{
  xdg.configFile."wallpaper.png".source =
    "${vars.appearance.bg.folder}/${vars.appearance.bg.wall}";
}
