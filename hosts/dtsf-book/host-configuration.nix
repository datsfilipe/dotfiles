{ lib, ... }:

let
  user = "dtsf";
  common = import ../common/configuration.nix;
in
lib.recursiveUpdate common {
  user = user;
  host = "dtsf-book";
  system = {
    load_nvidia_module = false;
    ollama = false;
    boot = "systemd";
    dpi = "144";
  };
  appearance = {
    bg = {
      folder = "/home/${user}/media/photos/wallpapers";
    };
  };
  environment = {
    desktop = "cinnamon";
  };
}
