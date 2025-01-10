{ lib, pkgs, mylib, zellij-switch, ... }: let
  packageFiles = lib.filter
    (path: !lib.strings.hasPrefix (toString ./overlays) (toString path))
    (mylib.file.scanPaths ./.);
  
  pkgsWithOverlays = pkgs.extend zellij-switch.overlays.default;

  packages = builtins.listToAttrs (
    map
      (file: {
        name = lib.strings.removeSuffix ".nix" (baseNameOf file);
        value = pkgsWithOverlays.callPackage file {};
      })
      packageFiles
  ) // {
    inherit (pkgsWithOverlays) zellij-switch;
  };
in
  packages
