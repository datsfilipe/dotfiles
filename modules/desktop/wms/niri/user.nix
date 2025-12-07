{
  pkgs,
  mypkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.desktop.wms.niri.user;
  generateConfig = cfg: builtins.concatStringsSep "\n" cfg.modules.desktop.wms.niri.user.rawConfigValues;
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
    home.packages = with pkgs; [
      yad
      wl-clipboard
      xwayland-satellite
    ];

    modules.desktop.nupkgs.packages = [mypkgs.niri];

    modules.desktop.wms.niri.user.rawConfigValues = [
      ''spawn-at-startup "sh" "-c" "wmain"''
      ''spawn-at-startup "sh" "-c" "udiskie --tray --notify"''
      ''spawn-at-startup "sh" "-c" "systemctl --user restart wallpaper.service"''
      ''spawn-at-startup "sh" "-c" "nm-applet"''

      (lib.concatStringsSep "\n" (map (m: ''
          output "${m.name}" {
            mode "${m.resolution}@${toString m.refreshRate}"
            scale ${m.scale}
            ${(
            if m.focus
            then "focus-at-startup"
            else ""
          )}
            transform "${(
            if m.nvidiaSettings.rotation == "left"
            then "90"
            else m.nvidiaSettings.rotation
          )}"
            position x=${toString m.nvidiaSettings.coordinate.x} y=${toString m.nvidiaSettings.coordinate.y}
            hot-corners { bottom-left; }
          }
        '')
        config.modules.hardware.monitors.monitors))

      (lib.fileContents ./conf/niri.kdl)
    ];

    xdg.configFile."niri/config.kdl".text = generateConfig config;
  };
}
