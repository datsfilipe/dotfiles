{lib, ...}:
with lib; {
  options.modules.shared.multi-monitors = {
    enable = mkEnableOption "Multi-monitor support";

    enableNvidiaSupport = mkEnableOption "NVIDIA support";

    monitors = mkOption {
      type = types.listOf (types.submodule {
        options = {
          name = mkOption {
            type = types.str;
          };
          resolution = mkOption {
            type = types.str;
          };
          refreshRate = mkOption {
            type = types.str;
          };
          nvidiaSettings = mkOption {
            type = types.submodule {
              options = {
                coordinate = mkOption {
                  type = types.submodule {
                    options = {
                      x = mkOption {
                        type = types.int;
                        default = 0;
                      };
                      y = mkOption {
                        type = types.int;
                        default = 0;
                      };
                    };
                  };
                  default = {};
                };
                forceFullCompositionPipeline = mkOption {
                  type = types.bool;
                  default = false;
                };
                rotation = mkOption {
                  type = types.str;
                  default = "normal";
                };
              };
            };
            default = {};
          };
        };
      });
      default = [];
    };
  };
}
