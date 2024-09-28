{ lib, ... }:

let
  user = "dtsf";
  common = import ../common/configuration.nix;
in
lib.recursiveUpdate common {
  user = user;
  host = "dtsf-book";
  system.load_nvidia_module = false;
  system.ollama = false;
  system.boot = "systemd";
  appearance.bg.wall = "25.png";
  appearance.bg.folder = "/home/${user}/media/photos/wallpapers";
}
