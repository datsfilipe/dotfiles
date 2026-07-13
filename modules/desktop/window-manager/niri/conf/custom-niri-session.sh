if systemctl --user -q is-active niri.service; then
  echo 'a niri session is already running.'
  exit 1
fi

systemctl --user reset-failed

if hash dbus-update-activation-environment 2>/dev/null; then
  dbus-update-activation-environment --systemd --all
fi

systemctl --user --wait start niri.service
systemctl --user start --job-mode=replace-irreversibly niri-shutdown.target
