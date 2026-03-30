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
    extraSessionCommands = ''
      export _JAVA_AWT_WM_NONREPARENTING=1
    '';
  };
}
