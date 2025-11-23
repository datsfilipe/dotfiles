{
  pkgs,
  config,
  lib,
  mylib,
  ...
} @ args:
with lib; let
  cfg = config.modules.desktop.wms.i3.user;
in {
  options.modules.desktop.wms.i3.user = {
    enable = mkEnableOption "i3 wm";
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
            description = "i3 configuration value";
          };
      in
        valueType;
      default = {};
    };
  };

  config = mkIf cfg.enable (
    mkMerge ([
        {
          xsession.windowManager.i3.config = cfg.settings;
        }
      ]
      ++ (import ./values args))
  );
}
