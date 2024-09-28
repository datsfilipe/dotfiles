{ lib, ... }:

let
  common = import ../common.nix;
in
lib.recursiveUpdate common {
  host = "dtsf-book";
  environment.term = "alacritty";
  environment.wm = "hyprland";
  system.load_nvidia_module = false;
}
