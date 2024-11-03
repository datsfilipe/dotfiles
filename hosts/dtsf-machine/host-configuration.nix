{ lib, ... }:

let
  common = import ../common/configuration.nix;
in
lib.recursiveUpdate common {
  host = "dtsf-machine";
  system.load_nvidia_module = true;
}
