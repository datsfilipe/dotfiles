{ lib, pkgs, ... }:

with lib; let
  pkg = pkgs.i3;
in {
  xsession.windowManager.i3 = {
    enable = true;
    package = pkg;
  };
}
