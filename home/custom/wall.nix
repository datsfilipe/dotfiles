{ inputs, ... }:

{
  xdg.configFile."wallpaper.png".source = "${inputs.walls}/17.png";
}
