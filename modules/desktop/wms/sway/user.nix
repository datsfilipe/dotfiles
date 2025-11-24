{
  pkgs,
  config,
  lib,
  mylib,
  ...
} @ args:
with lib; let
  cfg = config.modules.desktop.wms.sway.user;
in {
  options.modules.desktop.wms.sway.user = {
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
