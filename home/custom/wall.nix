{ inputs, ... }:

{
  xdg.configFile."wallpaper.png".source = "${inputs.walls}/14.png";
}
