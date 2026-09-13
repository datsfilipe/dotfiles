export PATH="@systemd@/bin:@coreutils@/bin:$PATH"

STATE_FILE="/tmp/focus-mode-active"

if [ -f "$STATE_FILE" ]; then
  rm "$STATE_FILE"

  wbar-autohide autohideOff
  systemctl --user start wallpaper.service

  notify-send "Focus mode" "Off"
else
  touch "$STATE_FILE"

  wbar-autohide autohideOn
  systemctl --user stop wallpaper.service

  notify-send "Focus mode" "On"
fi
