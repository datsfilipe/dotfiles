{ inputs, ... }:

{
  xdg.configFile."wallpaper.png".source = "${inputs.walls}/15.png";
}
