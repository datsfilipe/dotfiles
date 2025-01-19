{
  lib,
  astal,
  stdenv,
  dart-sass,
  stdenvNoCC,
  wrapGAppsHook,
  gobject-introspection,
  lua,
  ...
}: let
  platform =
    if stdenv.hostPlatform.system == "x86_64-linux"
    then stdenv.hostPlatform.system
    else throw "Unsupported system";
in
  astal.lib.mkLuaPackage {
    pkgs =
      {
        inherit lib stdenvNoCC wrapGAppsHook gobject-introspection lua;
      }
      // {system = platform;};
    name = "astal";
    src = ./conf;

    extraPackages = [
      astal.packages.${platform}.battery
      astal.packages.${platform}.wireplumber
      astal.packages.${platform}.tray
      dart-sass
    ];
  }
