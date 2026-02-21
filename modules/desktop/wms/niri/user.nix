{
  pkgs,
  mypkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.desktop.wms.niri.user;
  generateConfig = rootConfig: builtins.concatStringsSep "\n" rootConfig.modules.desktop.wms.niri.user.rawConfigValues;
  hostMonitors = config.modules.hardware.monitors.monitors or [];
  monitorCount = builtins.length hostMonitors;
in {
  options.modules.desktop.wms.niri.user = {
    enable = mkEnableOption "Niri configuration";

    rawConfigValues = mkOption {
      type = types.listOf types.lines;
      default = [];
      description = "List of raw Niri configuration snippets";
    };
  };

  config = mkIf cfg.enable {
    home.packages =
      (with pkgs; [
        niri
        wl-clipboard
        xwayland-satellite
      ])
      ++ [mypkgs.niri-stack-to-n];

    modules.desktop.wms.niri.user.rawConfigValues = [
      ''spawn-at-startup "sh" "-c" "wmain ${toString monitorCount}"''
      ''spawn-at-startup "sh" "-c" "udiskie --tray --notify"''
      ''spawn-at-startup "sh" "-c" "systemctl --user restart wallpaper.service"''
      ''spawn-at-startup "sh" "-c" "nm-applet"''
      ''spawn-at-startup "niri-stack-to-n"''

      (lib.concatStringsSep "\n" (map (m: ''
          output "${m.name}" {
            mode "${m.resolution}@${toString m.refreshRate}"
            scale ${m.scale or "1.0"}
            ${(
            if (m.focus or false)
            then "focus-at-startup"
            else ""
          )}
            transform "${(
            if m.nvidiaSettings.rotation == "left"
            then "90"
            else if m.nvidiaSettings.rotation == "right"
            then "270"
            else "normal"
          )}"
            position x=${toString m.nvidiaSettings.coordinate.x} y=${toString m.nvidiaSettings.coordinate.y}
            hot-corners { bottom-left; }
          }
        '')
        hostMonitors))

      (lib.fileContents ./conf/niri.kdl)
    ];

    xdg.configFile."niri/config.kdl".text = generateConfig config;
  };
}
