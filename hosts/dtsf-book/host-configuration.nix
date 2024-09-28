{ lib, vars, ... }:

let
  common = import ../common/configuration.nix;
in
lib.recursiveUpdate common {
  host = "dtsf-book";
  system.load_nvidia_module = false;
  system.ollama = true;
  system.boot = "systemd";
  appearance.bg.wall = "25.png";
  appearance.bg.folder = "/home/${vars.user}/media/photos/wallpapers";
}
