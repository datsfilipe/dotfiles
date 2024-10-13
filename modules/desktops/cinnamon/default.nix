{ lib, vars, ... }:

lib.mkIf (vars.environment.desktop == "cinnamon") {
  services = {
    displayManager = {
      defaultSession = "cinnamon";
    };

    libinput = {
      enable = true;
      mouse = {
        accelProfile = "flat";
        accelSpeed = "0";
      };
    };

    xserver = {
      enable = true;
      displayManager.lightdm.enable = true;
      desktopManager.cinnamon.enable = true;
    };
  };
  programs.dconf.enable = true;
}
