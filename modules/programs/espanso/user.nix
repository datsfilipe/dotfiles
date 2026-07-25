{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.modules.programs.espanso.user;
in {
  options.modules.programs.espanso.user.enable = lib.mkEnableOption "espanso text expander (Wayland)";

  config = lib.mkIf cfg.enable {
    services.espanso = {
      enable = true;
      package = pkgs.espanso-wayland;

      configs.default = {
        backend = "auto";
        toggle_key = "ALT";
      };

      matches.base.matches = [
        {
          trigger = ":date";
          replace = "{{mydate}}";
          vars = [
            {
              name = "mydate";
              type = "date";
              params.format = "%Y-%m-%d";
            }
          ];
        }
        {
          trigger = ":now";
          replace = "{{mytime}}";
          vars = [
            {
              name = "mytime";
              type = "date";
              params.format = "%H:%M";
            }
          ];
        }
        {
          trigger = ":email";
          replace = "filipe.lima@d3.com";
        }
        {
          trigger = ":shrug";
          replace = "¯\\_(ツ)_/¯";
        }
      ];
    };
  };
}
