{ inputs, ... }:

{
  xdg.configFile."wallpaper.png".source = "${inputs.walls}/11.png";
}
