{ inputs, ... }:

{
  xdg.configFile."wallpaper.png".source = "${inputs.walls}/21.png";
}
