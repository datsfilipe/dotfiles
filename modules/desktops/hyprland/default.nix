{ config, pkgs, hyprland, ... }:

let exec = "exec Hyprland";
in {
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
      mpvpaper
      grim
      slurp
      swappy
      swaybg
      swayimg
    ];
  };
}
