{
  lib,
  pkgs,
  mylib,
  meow,
  zellij-switch,
  linux-shimeji,
  ghostty,
  ...
}: let
  packageFiles =
    lib.filter
    (path:
      !lib.strings.hasPrefix (toString ./overlays) (toString path)
      && builtins.baseNameOf path != "home.nix"
    )
    (mylib.file.scanPaths ./. ".nix");

  pkgsWithOverlays = pkgs.extend zellij-switch.overlays.default;

  packages =
    builtins.listToAttrs (
      map
      (file: let
        name = lib.strings.removeSuffix ".nix" (baseNameOf file);
      in {
        name = name;
        value = pkgsWithOverlays.callPackage file {};
      })
      packageFiles
    )
    // {
      inherit (pkgsWithOverlays) zellij-switch;
      linux-shimeji = linux-shimeji.packages.${pkgs.system}.little-ghost-polite;
      ghostty = ghostty.packages.${pkgs.system}.ghostty-releasefast;
      meow = meow.packages.${pkgs.system}.default;
    };
in
  packages
