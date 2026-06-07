{
  config,
  pkgs,
  myvars,
  ...
}: let
  logFile = "${config.home.homeDirectory}/.cache/wallpapers/set-wallpaper.log";
  wallpaperRel = "walls/${baseNameOf myvars.hostsConfig.wallpaper}";

  setWallpaper = pkgs.writeShellScript "set-wallpaper" ''
    set -eu
    PATH="${pkgs.coreutils}/bin:/usr/bin:/bin"

    CACHE_DIR="$HOME/.cache/wallpapers"
    DEST="$CACHE_DIR/master.png"
    TMP="$CACHE_DIR/.master.png.tmp"
    REL="${wallpaperRel}"
    mkdir -p "$CACHE_DIR"

    SRC=""
    for base in "$HOME"/Library/CloudStorage/GoogleDrive-*; do
      [ -d "$base" ] || continue
      for sub in "My Drive" "."; do
        cand="$base/$sub/$REL"
        if [ -f "$cand" ]; then
          SRC="$cand"
          break 2
        fi
      done
    done

    if [ -n "$SRC" ]; then
      for attempt in 1 2 3 4 5 6; do
        if cat "$SRC" > "$TMP" 2>/dev/null && [ -s "$TMP" ]; then
          mv -f "$TMP" "$DEST"
          break
        fi
        rm -f "$TMP"
        sleep 3
      done
    fi

    if [ ! -s "$DEST" ]; then
      echo "[wallpaper] source not ready yet (is Google Drive syncing?)" >&2
      exit 0
    fi

    /usr/bin/osascript -e \
      "tell application \"System Events\" to tell every desktop to set picture to \"$DEST\""
  '';
in {
  launchd.agents.set-wallpaper = {
    enable = true;
    config = {
      ProgramArguments = ["${setWallpaper}"];
      RunAtLoad = true;
      StartInterval = 300;
      StandardOutPath = logFile;
      StandardErrorPath = logFile;
    };
  };
}
