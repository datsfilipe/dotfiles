{
  config,
  lib,
  pkgs,
  myvars,
  ...
}:
with lib; let
  monitorCfg = config.modules.hardware.monitors;
  monitorCount = let mons = monitorCfg.monitors or []; in if mons == [] then 1 else builtins.length mons;
  waylandEnabled =
    config.modules.desktop.wms.niri.system.enable
    || config.modules.desktop.wms.sway.system.enable;
in {
  options.modules.desktop.wallpaper = {
    enable = mkEnableOption "Wallpaper service";
    file = mkOption {
      type = types.path;
      default = "/run/media/dtsf/datsgames/walls/01.png";
      description = "Wallpaper path";
    };
  };

  config =
    mkIf (
      config.modules.desktop.wallpaper.enable
    ) {
      systemd.user.services.link-wallpaper = {
        enable = config.modules.desktop.wallpaper.enable;
        description = "Create wallpaper symlink";
        after = [
          "graphical-session.target"
        ];
        wantedBy = ["default.target" "graphical-session.target"];
        path = [pkgs.coreutils];
        script = ''
          for i in {1..30}; do
            if [[ -f "${config.modules.desktop.wallpaper.file}" ]]; then
              break
                fi
                sleep 1
                done

                if [[ -f "${config.modules.desktop.wallpaper.file}" ]]; then
                  mkdir -p /home/${myvars.username}/.local/share/wallpaper
                    ln -sf ${config.modules.desktop.wallpaper.file} /home/${myvars.username}/.local/share/wallpaper/current
                    fi
        '';
        serviceConfig = {
          KillMode = "mixed";
          Type = "oneshot";
          RemainAfterExit = true;
        };
      };

      systemd.user.services.wallpaper = {
        enable = config.modules.desktop.wallpaper.enable;
        description = "Set wallpaper";
        after = [
          "link-wallpaper.service"
          "graphical-session.target"
        ];
        wantedBy = ["default.target"];
        path =
          if waylandEnabled
          then with pkgs; [swaybg imagemagick coreutils gnugrep procps gnused bash]
          else with pkgs; [feh imagemagick];
        script = ''
          WALLPAPER="/home/${myvars.username}/.local/share/wallpaper/current"
          WIDTH=$(${pkgs.imagemagick}/bin/identify -format "%w" "$WALLPAPER")
          ${
            if waylandEnabled
            then ''
              if [ "$WIDTH" -ge 2800 ]; then
                SPAN_WALL_PATH="/home/${myvars.username}/.local/bin/span-wall"

                if [ -x "$SPAN_WALL_PATH" ]; then
                  SPAN_CMD="$SPAN_WALL_PATH"
                else
                  SPAN_CMD="span-wall"
                fi
                pkill -f swaybg || true

                ARGS=""
                ${concatMapStringsSep "\n" (monitor: ''
                  NAME="${monitor.name}"
                  RESOLUTION="${monitor.resolution}"
                  WIDTH=$(echo $RESOLUTION | cut -d'x' -f1)
                  HEIGHT=$(echo $RESOLUTION | cut -d'x' -f2)
                  X_POS="${toString monitor.nvidiaSettings.coordinate.x}"
                  Y_POS="${toString monitor.nvidiaSettings.coordinate.y}"
                  ROTATION="${monitor.nvidiaSettings.rotation or "normal"}"

                  if [ "$ROTATION" = "left" ] || [ "$ROTATION" = "right" ]; then
                    ARGS="$ARGS --output-$NAME=\"$HEIGHT $WIDTH $X_POS $Y_POS $ROTATION\""
                  else
                    ARGS="$ARGS --output-$NAME=\"$WIDTH $HEIGHT $X_POS $Y_POS $ROTATION\""
                  fi
                '')
                monitorCfg.monitors}

                eval "$SPAN_CMD \"$WALLPAPER\" $ARGS"
              else
                # Kill any existing swaybg instances
                pkill -f swaybg || true

                # Set wallpaper on each monitor
                ${concatMapStringsSep "\n" (monitor: ''
                  ${pkgs.swaybg}/bin/swaybg -o "${monitor.name}" -i "$WALLPAPER" -m fill &
                '')
                monitorCfg.monitors}
              fi
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
          KillMode = "mixed";
          Type = "oneshot";
          RemainAfterExit = true;
          Restart = "on-failure";
          RestartSec = 5;
        };
      };
    };
}
