{
  lib,
  pkgs,
  mylib,
  meow,
  unix-scripts,
  zellij-switch,
  linux-shimeji,
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

  pkgsWithOverlays =
    (pkgs.extend zellij-switch.overlays.default)
    // {unix-scripts = unix-scripts;};

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
            astalFile = ./astal/default.nix;
            scriptArgs =
              if toString file == toString scriptFile
              then {inherit unix-scripts;}
              else if toString file == toString astalFile
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
      linux-shimeji = linux-shimeji.packages.${pkgs.stdenv.hostPlatform.system}.little-ghost-polite;
      # ghostty = ghostty.packages.${pkgs.stdenv.hostPlatform.system}.ghostty-releasefast;
      meow = meow.packages.${pkgs.stdenv.hostPlatform.system}.default;
    };
in
  packages
