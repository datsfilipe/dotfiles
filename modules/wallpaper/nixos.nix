{ config, lib, pkgs, myvars, ... }:

with lib; {
  options.modules.desktop.wallpaper = {
    enable = mkEnableOption "Wallpaper service";
  };

  config =  mkIf (
    config.modules.desktop.wallpaper.enable &&
    config.services.xserver.enable
  ) {
    systemd.user.services.link-wallpaper = {
      description = "Create wallpaper symlink";
      after = [ "graphical-session.target" ];
      wantedBy = [ "default.target" ];
      path = [ pkgs.coreutils ];
      script = ''
        for i in {1..30}; do
          if [[ -f "${myvars.wallpaper}" ]]; then
            break
          fi
          sleep 1
        done

        if [[ -f "${myvars.wallpaper}" ]]; then
          mkdir -p /home/${myvars.username}/.local/share/wallpaper
          ln -sf ${myvars.wallpaper} /home/${myvars.username}/.local/share/wallpaper/current
        fi
      '';
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
    };

    systemd.user.services.wallpaper = {
      description = "Set wallpaper";
      after = [ "link-wallpaper.service" "graphical-session.target" ];
      wantedBy = [ "default.target" ];
      path = [ pkgs.feh ];
      script = ''
        ${pkgs.feh}/bin/feh --bg-fill /home/${myvars.username}/.local/share/wallpaper/current
      '';
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
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
