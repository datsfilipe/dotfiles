{ inputs, ... }:

{
  xdg.configFile."wallpaper.png".source = "${inputs.walls}/12.png";
}
