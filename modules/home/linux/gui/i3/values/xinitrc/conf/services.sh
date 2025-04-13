#!/bin/sh

restart_service_if_exited() {
  local service_name=$1
  if systemctl --user is-active --quiet "$service_name" && \
     systemctl --user show "$service_name" -p SubState | grep -q "SubState=exited"; then
    echo "restarting $service_name..."
    systemctl --user restart "$service_name"
  else
    echo "$service_name is not in 'active (exited)' state, skipping restart."
  fi
}

(
  restart_service_if_exited "wallpaper.service"
  restart_service_if_exited "link-wallpaper.service"
) &
