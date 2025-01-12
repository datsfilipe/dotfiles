{
  lib,
  pkgs,
  ...
}:
with lib; let
  pkg = pkgs.sway;
in {
  wayland.windowManager.sway = {
    enable = true;
    package = pkg;
  };
}
