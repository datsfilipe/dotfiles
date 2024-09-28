{ lib, ... }:

let
  common = import ../common/configuration.nix;
in
lib.recursiveUpdate common {
  host = "dtsf-book";
  system.load_nvidia_module = false;
  system.ollama = true;
  system.boot = "systemd";
}
