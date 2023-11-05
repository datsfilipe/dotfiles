{ config, inputs, pkgs, hyprland, ... }:

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
      inputs.ags.packages.${pkgs.system}.default
      inputs.anyrun.packages.${pkgs.system}.anyrun
      wl-clipboard
      mpvpaper
      grim
      slurp
      swappy
      swaybg
    ];
  };
}
