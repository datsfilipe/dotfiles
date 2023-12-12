{ inputs, ... }:

{
  xdg.configFile."wallpaper.png".source = "${inputs.walls}/07.png";
}
