{
  lib,
  pkgs,
  config,
  mylib,
  ...
}: let
  colorscheme = import ../../../themes/${config.modules.desktop.colorscheme.theme}.nix;
in {
  configOptions.modules.desktop.conf = {
    enableBottomIntegration = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };

    bottom.settings = lib.mkOption {
      type = lib.types.attrsOf lib.types.anything;
      default = {};
      apply = lib.recursiveUpdate;
    };
  };

  configContent = lib.mkIf (config.programs.bottom.enable && config.modules.desktop.conf.enableBottomIntegration) {
    xdg.configFile."bottom/bottom.toml".text =
      mylib.format.sections [
        "styles.widgets"
        "styles.graphs"
        "styles.tables"
        "styles.cpu"
        "styles.memory"
        "styles.network"
        "styles.battery"
      ] {
        "styles.widgets" = {
          border_color = "reset";
          selected_border_color = "#${colorscheme.colors.blue}";
          widget_title = {
            color = "#${colorscheme.colors.blue}";
            bold = true;
          };
          text = {color = "#${colorscheme.colors.fg}";};
          selected_text = {
            color = "#${colorscheme.colors.bg}";
            bg_color = "#${colorscheme.colors.blue}";
            bold = true;
          };
          disabled_text = {color = "#${colorscheme.colors.altbg}";};
          thread_text = {color = "#${colorscheme.colors.green}";};
        };

        "styles.graphs" = {
          graph_color = "#${colorscheme.colors.fg}";
          legend_text = {color = "#${colorscheme.colors.fg}";};
        };

        "styles.tables" = {
          headers = {
            color = "#${colorscheme.colors.blue}";
            bold = true;
          };
        };

        "styles.cpu" = {
          all_entry_color = "#${colorscheme.colors.blue}";
          avg_entry_color = "#${colorscheme.colors.yellow}";
          cpu_core_colors = [
            "#${colorscheme.colors.green}"
            "#${colorscheme.colors.magenta}"
            "#${colorscheme.colors.red}"
            "#${colorscheme.colors.cyan}"
          ];
        };

        "styles.memory" = {
          ram_color = "#${colorscheme.colors.blue}";
          cache_color = "#${colorscheme.colors.yellow}";
          swap_color = "#${colorscheme.colors.red}";
          arc_color = "#${colorscheme.colors.magenta}";
          gpu_colors = [
            "#${colorscheme.colors.green}"
            "#${colorscheme.colors.magenta}"
            "#${colorscheme.colors.red}"
            "#${colorscheme.colors.cyan}"
          ];
        };

        "styles.network" = {
          rx_color = "#${colorscheme.colors.green}";
          tx_color = "#${colorscheme.colors.blue}";
          rx_total_color = "#${colorscheme.colors.fg}";
          tx_total_color = "#${colorscheme.colors.fg}";
        };

        "styles.battery" = {
          high_battery_color = "#${colorscheme.colors.green}";
          medium_battery_color = "#${colorscheme.colors.yellow}";
          low_battery_color = "#${colorscheme.colors.red}";
        };
      };
  };
}
