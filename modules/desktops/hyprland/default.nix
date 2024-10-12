{ config, lib, pkgs, hyprland, vars, ... }:

with lib; let exec = "exec Hyprland";
in mkIf (vars.environment.desktop == "hyprland") {
  programs = {
    hyprland = {
      enable = true;

      xwayland.enable = true;
    };

    waybar.enable = false;
  };

  environment = {
    loginShellInit = ''
      if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
        ${exec}
      fi
    '';

    systemPackages = with pkgs; [
      wl-clipboard
      grim
      slurp
      swappy
      swaybg
      swayimg
    ];
  };
}
