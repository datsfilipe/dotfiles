{ config, lib, pkgs, myvars, ... }:

with lib; {
  options.modules.desktop.wallpaper = {
    enable = mkEnableOption "Wallpaper service";
  };

  config = mkIf config.modules.desktop.wallpaper.enable {
    systemd.user.services.wallpaper = mkIf (config.modules.desktop.xorg.enable) {
      description = "Set wallpaper";
      wantedBy = [ "default.target" ];
      path = [ pkgs.feh ];
      script = ''
        sleep 3
        ${pkgs.feh}/bin/feh --bg-fill ${myvars.wallpaper}
      '';

      serviceConfig = {
        Type = "oneshot";
        Environment = [
          "HOME=/home/${myvars.username}"
          "DISPLAY=:0"
        ];
      };
    };
  };
}
