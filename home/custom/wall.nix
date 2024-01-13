{ inputs, ... }:

{
  xdg.configFile."wallpaper.png".source = "${inputs.walls}/18.png";
}
