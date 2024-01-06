{ inputs, ... }:

{
  xdg.configFile."wallpaper.png".source = "${inputs.walls}/08.png";
}
