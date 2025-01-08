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
        feh --bg-fill "${myvars.wallpaper}"
      '';
      serviceConfig = {
        Type = "forking";
        Environment = [
          "HOME=/home/${myvars.username}"
          "DISPLAY=:0"
        ];
        Restart = "on-failure";
        RestartSec = 5;
      };
    };
  };
}
