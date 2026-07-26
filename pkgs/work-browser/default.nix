{
  lib,
  writeShellApplication,
  chromium,
  bubblewrap,
  coreutils,
  nssTools,
  jq,
  makeDesktopItem,
  symlinkJoin,
}: let
  launcher = writeShellApplication {
    name = "work-browser";
    runtimeInputs = [chromium bubblewrap coreutils nssTools jq];
    text = builtins.readFile ./conf/launch.sh;
  };

  desktopItem = makeDesktopItem {
    name = "work-browser";
    desktopName = "Work Browser";
    genericName = "Sandboxed work browser";
    exec = "work-browser %U";
    icon = "chromium";
    categories = ["Network" "WebBrowser"];
    startupWMClass = "Chromium";
  };
in
  symlinkJoin {
    name = "work-browser";
    paths = [launcher desktopItem];
    meta = {
      description = "Chromium confined to ~/Work via bubblewrap, on XWayland, with an isolated profile";
      mainProgram = "work-browser";
      platforms = lib.platforms.linux;
    };
  }
