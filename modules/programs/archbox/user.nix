{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.programs.archbox.user;
  containerName = "arch";
in {
  options.modules.programs.archbox.user.enable = mkEnableOption "Arch Linux dev container via distrobox";

  config = mkIf cfg.enable {
    programs.distrobox = {
      enable = true;
      settings = {
        container_manager = "docker";
      };
      containers = {
        ${containerName} = {
          image = "docker.io/library/archlinux:latest";
          additional_packages = "base-devel git";
        };
      };
    };

    programs.direnv.stdlib = ''
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
          printf '#!/bin/sh\nexec distrobox enter ${containerName} -- env PATH="$HOME/.asdf/shims:/usr/local/bin:/usr/bin:/bin" %s "$@"\n' "$cmd" > "$shim_dir/$cmd"
          chmod +x "$shim_dir/$cmd"
        done
        PATH_add "$shim_dir"
      }
    '';

    programs.fish.functions = {
      abox = ''
        if test (count $argv) -eq 0
          distrobox enter ${containerName}
        else
          distrobox enter ${containerName} -- $argv
        end
      '';
    };
  };
}
