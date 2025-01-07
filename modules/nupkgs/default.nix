{ lib, pkgs, mylib, ... }: let
  packages = builtins.listToAttrs (
    map 
      (file: 
        let
          name = lib.strings.removeSuffix ".nix" (baseNameOf file);
        in {
          inherit name;
          value = pkgs.callPackage file {};
        }
      )
      (mylib.scanPaths ./.)
  );
in
  packages
