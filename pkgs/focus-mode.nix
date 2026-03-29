{
  writeShellScriptBin,
  systemd,
  coreutils,
  ...
}:
writeShellScriptBin "focus-mode" ''
  export PATH="${systemd}/bin:${coreutils}/bin:$PATH"

  STATE_FILE="/tmp/focus-mode-active"

  if [ -f "$STATE_FILE" ]; then
    # disable focus mode
    rm "$STATE_FILE"

    systemctl --user start wallpaper.service

    notify-send "Focus mode" "Off"
  else
    # enable focus mode
    touch "$STATE_FILE"

    wmain autohide-on
    systemctl --user stop wallpaper.service

    notify-send "Focus mode" "On"
  fi
''
