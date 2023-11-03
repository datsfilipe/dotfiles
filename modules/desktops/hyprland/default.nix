{ config, pkgs, system, hyprland, ... }:

let exec = "exec Hyprland";
in {
  programs = {
    hyprland = {
      enable = true;

      xwayland.enable = true;
      enableNvidiaPatches = false;
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
      mpvpaper
      wl-clipboard
      grim
      slurp
      swappy
      swaybg
    ];
  };
}
