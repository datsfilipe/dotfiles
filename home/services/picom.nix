{ pkgs, ... }:

{
  services.picom.enable = true;
  xdg.configFile."picom.conf".source = ../../dotfiles/picom.conf;
}
