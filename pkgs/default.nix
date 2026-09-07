{
  lib,
  pkgs,
  mylib,
  zellij-switch,
  theme,
  gif-filename,
  ...
}: let
  packageFiles =
    lib.filter
    (
      path:
        !lib.strings.hasPrefix (toString ./overlays) (toString path)
        && builtins.baseNameOf path != "home.nix"
    )
    (mylib.file.scanPaths ./. ".nix");

  pkgsWithOverlays = pkgs.extend zellij-switch.overlays.default;

  colorscheme = import ../modules/themes/${theme}.nix;

  packages =
    builtins.listToAttrs (
      map
      (
        file: let
          fileName = baseNameOf file;
          name =
            if fileName == "default.nix"
            then baseNameOf (dirOf file)
            else lib.strings.removeSuffix ".nix" fileName;
        in {
          name = name;
          value = let
            astalFile = ./astal/default.nix;
            scriptArgs =
              if toString file == toString astalFile
              then {inherit colorscheme gif-filename;}
              else {};
          in
            pkgsWithOverlays.callPackage file scriptArgs;
        }
      )
      packageFiles
    )
    // {
      inherit (pkgsWithOverlays) zellij-switch;
    };
in
  packages
