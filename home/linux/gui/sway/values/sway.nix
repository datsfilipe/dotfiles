{
  lib,
  pkgs-unstable,
  ...
}:
with lib; let
  pkg = pkgs-unstable.sway;
in {
  wayland.windowManager.sway = {
    enable = true;
    package = pkg;
  };
}
