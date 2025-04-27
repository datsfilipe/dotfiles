{
  pkgs,
  mypkgs,
  config,
  lib,
  ...
} @ args: let
  generateConfig = config:
    builtins.concatStringsSep "\n" config.modules.desktop.niri.rawConfigValues;
  packages = import ./packages.nix args;
in {
  imports = [
    ./packages.nix
  ];

  options.modules.desktop.niri = {
    enable = lib.mkEnableOption "Niri configuration";

    rawConfigValues = lib.mkOption {
      type = lib.types.listOf lib.types.lines;
      default = [];
      description = "List of raw Niri configuration snippets";
    };
  };

  config = lib.mkIf config.modules.desktop.niri.enable {
    modules.desktop.niri.rawConfigValues = [
      ''spawn-at-startup "${mypkgs.astal}/bin/astal"''
      ''spawn-at-startup "sh" "-c" "udiskie --tray --notify"''
      ''spawn-at-startup "sh" "-c" "systemctl --user restart wallpaper.service"''
      ''spawn-at-startup "sh" "-c" "${pkgs.dunst}/bin/dunst --config ${config.home.homeDirectory}/.config/dunstrc"''

      (lib.concatStringsSep "\n" (map (m: ''
          output "${m.name}" {
            mode "${m.resolution}@${toString m.refreshRate}"
            scale 1
            transform "${(
            if m.nvidiaSettings.rotation == "left"
            then "90"
            else m.nvidiaSettings.rotation
          )}"
            position x=${toString m.nvidiaSettings.coordinate.x} y=${toString m.nvidiaSettings.coordinate.y}
          }
        '')
        config.modules.shared.multi-monitors.monitors))

      (lib.fileContents ./conf/niri.kdl)
    ];

    xdg.configFile."niri/config.kdl".text = generateConfig config;
  };
}
