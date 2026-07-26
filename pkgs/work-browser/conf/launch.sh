profile="${XDG_DATA_HOME:-$HOME/.local/share}/work-browser"
work="$HOME/Work"
runtime="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"
nssdb="$profile/pki/nssdb"
servercert="/run/secrets/certs/server"

mkdir -p "$profile" "$work" "$nssdb"

if [ ! -f "$nssdb/cert9.db" ]; then
  certutil -N -d "sql:$nssdb" --empty-password >/dev/null 2>&1 || true
fi
if [ -r "$servercert" ]; then
  certutil -D -d "sql:$nssdb" -n dtsf-server >/dev/null 2>&1 || true
  certutil -A -d "sql:$nssdb" -n dtsf-server -t "C,," -i "$servercert" >/dev/null 2>&1 || true
fi

prefs="$profile/chromium/Default/Preferences"
mkdir -p "$(dirname "$prefs")"
if [ ! -f "$prefs" ]; then
  printf '{}' >"$prefs"
fi
ftmp="$(mktemp)"
jq '
  .webkit.webprefs.fonts.standard.Zyyy = "Inter"
  | .webkit.webprefs.fonts.serif.Zyyy = "Inter"
  | .webkit.webprefs.fonts.sansserif.Zyyy = "Inter"
  | .webkit.webprefs.fonts.fixed.Zyyy = "JetBrainsMono Nerd Font"
' "$prefs" >"$ftmp"
mv "$ftmp" "$prefs"

binds=(
  --ro-bind /nix/store /nix/store
  --ro-bind-try /run/current-system /run/current-system
  --ro-bind-try /run/opengl-driver /run/opengl-driver
  --ro-bind-try /run/opengl-driver-32 /run/opengl-driver-32
  --ro-bind /etc /etc
  --ro-bind-try /sys /sys
  --ro-bind-try /run/udev /run/udev
  --proc /proc
  --dev /dev
  --tmpfs /dev/shm
  --dev-bind-try /dev/dri /dev/dri
  --dev-bind-try /dev/bus/usb /dev/bus/usb
  --tmpfs /tmp
  --bind-try /tmp/.X11-unix /tmp/.X11-unix
  --tmpfs "$HOME"
  --bind "$profile" "$profile"
  --bind "$nssdb" "$HOME/.pki/nssdb"
  --bind "$work" "$work"
  --symlink Work "$HOME/Downloads"
  --tmpfs "$runtime"
  --bind-try "$runtime/pipewire-0" "$runtime/pipewire-0"
  --bind-try "$runtime/pulse" "$runtime/pulse"
  --chdir "$HOME"
  --unsetenv NIXOS_OZONE_WL
  --unsetenv WAYLAND_DISPLAY
  --unshare-pid
  --unshare-uts
  --unshare-ipc
  --unshare-cgroup-try
  --die-with-parent
  --new-session
)

if [ -n "${XAUTHORITY:-}" ] && [ -e "${XAUTHORITY:-}" ]; then
  binds+=(--ro-bind "$XAUTHORITY" "$XAUTHORITY")
fi

for dev in /dev/nvidia* /dev/video* /dev/hidraw*; do
  if [ -e "$dev" ]; then
    binds+=(--dev-bind "$dev" "$dev")
  fi
done

exec bwrap "${binds[@]}" \
  chromium \
  --user-data-dir="$profile/chromium" \
  --ozone-platform=x11 \
  --disable-features=Vulkan \
  --no-first-run \
  --no-default-browser-check \
  "$@"
