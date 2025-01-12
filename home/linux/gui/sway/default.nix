{
  pkgs,
  config,
  lib,
  anyrun,
  ...
} @ args:
with lib; let
  cfg = config.modules.desktop.sway;
in {
  options.modules.desktop.sway = {
    enable = mkEnableOption "sway wm";
    settings = lib.mkOption {
      type = with lib.types; let
        valueType =
          nullOr (oneOf [
            bool
            int
            float
            str
            path
            (attrsOf valueType)
            (listOf valueType)
          ])
          // {
            description = "sway configuration value";
          };
      in
        valueType;
      default = {};
    };
  };

  config = mkIf cfg.enable (
    mkMerge ([
        {
          wayland.windowManager.sway.config = cfg.settings;
        }
      ]
      ++ (import ./values args))
  );
}
