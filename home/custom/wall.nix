{ inputs, ... }:

{
  xdg.configFile."wallpaper.png".source = "${inputs.walls}/13.png";
}
