{
  lib,
  pkgs,
  mylib,
  astal,
  zellij-switch,
  linux-shimeji,
  ghostty,
  ...
}: let
  packageFiles =
    lib.filter
    (path: !lib.strings.hasPrefix (toString ./overlays) (toString path))
    (mylib.file.scanPaths ./.);

  pkgsWithOverlays = pkgs.extend zellij-switch.overlays.default;

  packages =
    builtins.listToAttrs (
      map
      (file: let
        name = lib.strings.removeSuffix ".nix" (baseNameOf file);
      in {
        name = name;
        value = pkgsWithOverlays.callPackage file (
          if name == "astal"
          then {
            inherit astal;
          }
          else {}
        );
      })
      packageFiles
    )
    // {
      inherit (pkgsWithOverlays) zellij-switch;
      linux-shimeji = linux-shimeji.packages.${pkgs.system}.little-ghost-polite;
      ghostty = ghostty.packages.${pkgs.system}.default;
    };
in
  packages
