use_arch() {
  local shim_dir cmd tool expanded
  shim_dir="$(direnv_layout_dir)/arch-bin"
  rm -rf "$shim_dir"
  mkdir -p "$shim_dir"
  if [ "$#" -eq 0 ]; then
    set -- asdf node python
  fi
  expanded=""
  for tool in "$@"; do
    case "$tool" in
    node) expanded="$expanded node npm npx corepack" ;;
    python) expanded="$expanded python python3 pip pip3" ;;
    cargo) expanded="$expanded cargo rustc rustfmt" ;;
    *) expanded="$expanded $tool" ;;
    esac
  done
  for cmd in $expanded; do
    printf '#!/bin/sh\nexec distrobox enter @containerName@ -- env PATH="$HOME/.asdf/shims:/usr/local/bin:/usr/bin:/bin" %s "$@"\n' "$cmd" >"$shim_dir/$cmd"
    chmod +x "$shim_dir/$cmd"
  done
  PATH_add "$shim_dir"
}
