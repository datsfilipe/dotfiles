{
  pkgs,
  config,
  lib,
  anyrun,
  ...
} @ args:
with lib; let
  cfg = config.modules.desktop.i3;
in {
  imports = [
    ./options
  ];

  options.modules.desktop.i3 = {
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
