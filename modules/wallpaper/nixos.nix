{
  config,
  lib,
  pkgs,
  myvars,
  ...
}:
with lib; {
  options.modules.desktop.wallpaper = {
    enable = mkEnableOption "Wallpaper service";
  };

  config =
    mkIf (
      config.modules.desktop.wallpaper.enable
    ) {
      systemd.user.services.link-wallpaper = {
        description = "Create wallpaper symlink";
        after = [
          (
            if config.modules.desktop.wayland.enable
            then "sway-session.target"
            else "graphical-session.target"
          )
        ];
        wantedBy = ["default.target"];
        path = [pkgs.coreutils];
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
        after = [
          "link-wallpaper.service"
          (
            if config.modules.desktop.wayland.enable
            then "sway-session.target"
            else "graphical-session.target"
          )
        ];
        wantedBy = ["default.target"];
        path =
          if config.modules.desktop.wayland.enable
          then []
          else [pkgs.feh];
        script = ''
          ${
            if config.modules.desktop.wayland.enable
            then ''
              swaymsg output "*" bg /home/${myvars.username}/.local/share/wallpaper/current fill
            ''
            else ''
              ${pkgs.feh}/bin/feh --bg-fill /home/${myvars.username}/.local/share/wallpaper/current
            ''
          }
        '';
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          Environment = [
            "HOME=/home/${myvars.username}"
            (
              if config.modules.desktop.xorg.enable
              then "DISPLAY=:0"
              else ""
            )
          ];
          Restart = "on-failure";
          RestartSec = 5;
        };
      };
    };
}
