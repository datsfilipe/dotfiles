{
  config,
  lib,
  pkgs,
  myvars,
  ...
}:
with lib; let
  monitorCount = builtins.length config.modules.shared.multi-monitors.monitors or 1;
in {
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
          "graphical-session.target"
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
          "graphical-session.target"
        ];
        wantedBy = ["default.target"];
        path =
          if config.modules.desktop.wayland.enable
          then [pkgs.sway]
          else [pkgs.feh];
        script = ''
          WALLPAPER="/home/${myvars.username}/.local/share/wallpaper/current"
          WIDTH=$(${pkgs.imagemagick}/bin/identify -format "%w" "$WALLPAPER")
          ${
            if config.modules.desktop.wayland.enable
            then ''
              ${pkgs.sway}/bin/swaymsg output "*" bg "$WALLPAPER"
            ''
            else ''
              if [ "$WIDTH" -ge 2800 ]; then
                ${pkgs.feh}/bin/feh --bg-fill --no-xinerama "$WALLPAPER"
              else
                monitors=()
                for ((i=0; i<${toString monitorCount}; i++)); do
                  monitors+=("$WALLPAPER")
                done
                sleep 2 && ${pkgs.feh}/bin/feh --bg-fill "''${monitors[@]}"
              fi
            ''
          }
        '';
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          Restart = "on-failure";
          RestartSec = 5;
        };
      };
    };
}
