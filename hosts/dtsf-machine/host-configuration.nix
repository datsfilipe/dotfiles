{ lib, ... }:

let
  common = import ../common.nix;
in
lib.recursiveUpdate common {
  host = "dtsf-machine";
}
