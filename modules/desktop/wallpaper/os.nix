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

  getWidth = m: builtins.fromJSON (builtins.elemAt (splitString "x" m.resolution) 0);
  getHeight = m: builtins.fromJSON (builtins.elemAt (splitString "x" m.resolution) 1);

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

      path = [pkgs.swaybg];

      script = ''
        CACHE_DIR="/home/${myvars.username}/.cache/wallpapers"

        if [ ! -f "$CACHE_DIR/master.png" ]; then
          echo "No cache found. Waiting for updater..."
          sleep 5
          exit 1
        fi

        echo "Starting swaybg from cache..."
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
      after =
        ["graphical-session.target"]
        ++ (optional config.modules.services.gdrive.enable "rclone-gdrive-mount.service");
      wantedBy = ["graphical-session.target"];

      path = with pkgs; [imagemagick coreutils procps diffutils gawk systemd];

      script = ''
        SOURCE_WALLPAPER="${cfg.file}"
        CACHE_DIR="/home/${myvars.username}/.cache/wallpapers"
        SUM_FILE="$CACHE_DIR/source.md5"
        mkdir -p "$CACHE_DIR"

        CANVAS_W="${toString totalWidth}"
        CANVAS_H="${toString totalHeight}"

        echo "[Updater] Checking source..."
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
        RENDERER_ACTIVE=$(systemctl --user is-active wallpaper.service)

        if [ "$CURRENT_SUM" == "$SAVED_SUM" ] && [ -f "$CACHE_DIR/master.png" ]; then
           echo "[Updater] Hash match ($CURRENT_SUM)."

           if [ "$RENDERER_ACTIVE" != "active" ]; then
              echo "[Updater] Renderer not active. Starting it."
              systemctl --user start wallpaper.service
           else
              echo "[Updater] Renderer active and valid. Doing nothing."
           fi
           exit 0
        fi

        echo "[Updater] Update detected or cache invalid. Processing..."

        ${pkgs.imagemagick}/bin/magick "$SOURCE_WALLPAPER" \
          -resize "$CANVAS_W"x"$CANVAS_H"^ \
          -gravity center \
          -extent "$CANVAS_W"x"$CANVAS_H" \
          "$CACHE_DIR/master.png"

        ${cropLogic}

        echo "$CURRENT_SUM" > "$SUM_FILE"

        echo "[Updater] Restarting renderer..."
        systemctl --user restart wallpaper.service
      '';

      serviceConfig = {
        Type = "oneshot";
      };
    };
  };
}
