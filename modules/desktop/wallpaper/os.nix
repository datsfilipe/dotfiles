{
  config,
  lib,
  pkgs,
  myvars,
  ...
}:
with lib; let
  cfg = config.modules.desktop.wallpaper;
  monitorCfg = config.modules.hardware.monitors;
  activeMonitors = monitorCfg.monitors or [];

  getRawWidth = m: builtins.fromJSON (builtins.elemAt (splitString "x" m.resolution) 0);
  getRawHeight = m: builtins.fromJSON (builtins.elemAt (splitString "x" m.resolution) 1);

  isRotated = m: let
    rotation = m.nvidiaSettings.rotation or "normal";
  in
    rotation == "left" || rotation == "right";

  getWidth = m:
    if isRotated m
    then getRawHeight m
    else getRawWidth m;
  getHeight = m:
    if isRotated m
    then getRawWidth m
    else getRawHeight m;

  getMonitorMaxX = m: m.nvidiaSettings.coordinate.x + (getWidth m);
  getMonitorMaxY = m: m.nvidiaSettings.coordinate.y + (getHeight m);

  totalWidth =
    if activeMonitors == []
    then 1920
    else foldl' (acc: m: max acc (getMonitorMaxX m)) 0 activeMonitors;
  totalHeight =
    if activeMonitors == []
    then 1080
    else foldl' (acc: m: max acc (getMonitorMaxY m)) 0 activeMonitors;

  cropLogic =
    concatMapStringsSep "\n" (m: let
      w = toString (getWidth m);
      h = toString (getHeight m);
      x = toString m.nvidiaSettings.coordinate.x;
      y = toString m.nvidiaSettings.coordinate.y;
      name = m.name;
    in ''
      echo "[Wallpaper] Cropping ${name}: ${w}x${h} at ${x},${y}..."
      ${pkgs.imagemagick}/bin/magick "$CACHE_DIR/master.png" \
        -crop "${w}x${h}+${x}+${y}" \
        +repage \
        "$CACHE_DIR/${name}.png"
    '')
    activeMonitors;

  swaybgArgs =
    concatMapStringsSep " " (
      m: "-o ${m.name} -i $CACHE_DIR/${m.name}.png"
    )
    activeMonitors;
in {
  options.modules.desktop.wallpaper = {
    enable = mkEnableOption "Wallpaper service";
    file = mkOption {
      type = types.path;
      default = "/home/${myvars.username}/gdrive/walls/01.png";
      description = "Master wallpaper path";
    };
  };

  config = mkIf cfg.enable {
    systemd.user.services.wallpaper = {
      enable = true;
      description = "Wallpaper Renderer";
      after = ["graphical-session.target"];
      wantedBy = ["graphical-session.target"];

      unitConfig.ConditionEnvironment = "!XDG_CURRENT_DESKTOP=GNOME";

      path = [pkgs.swaybg];
      script = ''
        CACHE_DIR="/home/${myvars.username}/.cache/wallpapers"
        if [ ! -f "$CACHE_DIR/master.png" ]; then
          sleep 5
          exit 1
        fi
        exec ${pkgs.swaybg}/bin/swaybg ${swaybgArgs} -m fill
      '';
      serviceConfig = {
        Type = "simple";
        Restart = "on-failure";
        RestartSec = "2s";
      };
    };

    systemd.user.services.wallpaper-updater = {
      enable = true;
      description = "Wallpaper Updater Logic";
      after = ["graphical-session.target"] ++ (optional config.modules.services.gdrive.enable "rclone-gdrive-mount.service");
      wantedBy = ["graphical-session.target"];

      path = with pkgs; [imagemagick coreutils procps diffutils gawk systemd glib];

      script = ''
        SOURCE_WALLPAPER="${cfg.file}"
        CACHE_DIR="/home/${myvars.username}/.cache/wallpapers"
        SUM_FILE="$CACHE_DIR/source.md5"
        ZOOM_FILE="$CACHE_DIR/zoom.txt"
        mkdir -p "$CACHE_DIR"

        CANVAS_W="${toString totalWidth}"
        CANVAS_H="${toString totalHeight}"
        ZOOM="${toString (myvars.hostsConfig.wallpaper-zoom or 0)}"

        for i in {1..30}; do
          if [[ -f "$SOURCE_WALLPAPER" ]]; then break; fi
          sleep 1
        done

        if [ ! -f "$SOURCE_WALLPAPER" ]; then
           echo "[Updater] Source not found. Assuming offline."
           exit 0
        fi

        CURRENT_SUM=$(md5sum "$SOURCE_WALLPAPER" | awk '{print $1}')
        SAVED_SUM=$(cat "$SUM_FILE" 2>/dev/null || echo "")
        SAVED_ZOOM=$(cat "$ZOOM_FILE" 2>/dev/null || echo "")

        CHANGES_DETECTED=0
        if [ "$CURRENT_SUM" != "$SAVED_SUM" ] || [ "$ZOOM" != "$SAVED_ZOOM" ] || [ ! -f "$CACHE_DIR/master.png" ]; then
           CHANGES_DETECTED=1
        fi

        if [ "$CHANGES_DETECTED" -eq 1 ]; then
           echo "[Updater] Change detected. Processing..."
           RESIZE_W=$(awk -v w="$CANVAS_W" -v z="$ZOOM" 'BEGIN { printf "%.0f", w * (1 + z) }')
           RESIZE_H=$(awk -v h="$CANVAS_H" -v z="$ZOOM" 'BEGIN { printf "%.0f", h * (1 + z) }')

           ${pkgs.imagemagick}/bin/magick "$SOURCE_WALLPAPER" \
             -resize "''${RESIZE_W}x''${RESIZE_H}^" \
             -gravity center \
             -extent "$CANVAS_W"x"$CANVAS_H" \
             "$CACHE_DIR/master.png"

           ${cropLogic}

           echo "$CURRENT_SUM" > "$SUM_FILE"
           echo "$ZOOM" > "$ZOOM_FILE"
        else
           echo "[Updater] No changes detected."
        fi

        if [[ "$XDG_CURRENT_DESKTOP" == *"GNOME"* ]]; then
            echo "[Updater] Detected GNOME environment."
            gsettings set org.gnome.desktop.background picture-uri "file://$CACHE_DIR/master.png"
            gsettings set org.gnome.desktop.background picture-uri-dark "file://$CACHE_DIR/master.png"

            systemctl --user stop wallpaper.service || true

        else
            echo "[Updater] Detected Sway/Niri/Other."

            if [ "$CHANGES_DETECTED" -eq 1 ]; then
                systemctl --user restart wallpaper.service
            else
                systemctl --user start wallpaper.service
            fi
        fi
      '';

      serviceConfig = {
        Type = "oneshot";
      };
    };
  };
}
