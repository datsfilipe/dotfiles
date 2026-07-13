{
  config,
  pkgs,
  mylib,
  myvars,
  ...
}: let
  logFile = "${config.home.homeDirectory}/.cache/wallpapers/set-wallpaper.log";
  wallpaperRel = "walls/${baseNameOf myvars.hostsConfig.wallpaper}";

  setWallpaper = pkgs.writeShellScript "set-wallpaper" (mylib.file.substitute ./conf/set-wallpaper.sh {
    "@coreutils@" = "${pkgs.coreutils}";
    "@wallpaperRel@" = wallpaperRel;
  });
in {
  launchd.agents.set-wallpaper = {
    enable = true;
    config = {
      ProgramArguments = ["${setWallpaper}"];
      RunAtLoad = true;
      StartInterval = 300;
      StandardOutPath = logFile;
      StandardErrorPath = logFile;
    };
  };
}
