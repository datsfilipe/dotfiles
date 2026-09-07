{
  lib,
  pkgs,
  mylib,
  unix-scripts,
  zellij-switch,
  theme,
  ...
}: let
  packageFiles =
    lib.filter
    (
      path:
        !lib.strings.hasPrefix (toString ./overlays) (toString path)
    )
    (mylib.file.scanPaths ./. ".nix");

  pkgsWithOverlays =
    (pkgs.extend zellij-switch.overlays.default)
    // {inherit unix-scripts;};

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
            scriptFile = ./scripts/default.nix;
            quickshellFile = ./quickshell/default.nix;
            scriptArgs =
              if toString file == toString scriptFile
              then {inherit unix-scripts;}
              else if toString file == toString quickshellFile
              then {inherit colorscheme;}
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
