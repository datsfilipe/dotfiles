{ pkgs, lib, vars, ... }:

with lib; mkIf (vars.environment.desktop == "i3") {
  services.picom.enable = true;
  xdg.configFile."picom.conf".source = ../../dotfiles/picom.conf;
}
