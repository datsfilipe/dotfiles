{ inputs, ... }:

{
  xdg.configFile."wallpaper.png".source = "${inputs.walls}/16.png";
}
