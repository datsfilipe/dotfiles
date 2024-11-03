{ lib, ... }:

let
  user = "dtsf";
  common = import ../common/configuration.nix;
in
lib.recursiveUpdate common {
  user = user;
  host = "dtsf-book";
  appearance.bg.folder = "/home/${user}/media/photos/wallpapers";
  environment.desktop = "cinnamon";
  system = {
    boot = "systemd";
    dpi = "144";
  };
}
