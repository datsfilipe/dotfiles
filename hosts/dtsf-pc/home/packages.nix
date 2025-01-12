{ config, pkgs, mypkgs, ... }: {
  home.packages = with pkgs; [
    qbittorrent
    zoom-us
    slack
    beekeeper-studio
    bitwarden
  ];

  modules.desktop.nupkgs.packages = with mypkgs; [
    devtunnel-cli
    linux-shimeji
  ];

  programs.i3status = {
    enable = true;
    enableDefault = false;
    modules = {
      "volume master" = {
        position = 1;
        settings = {
          format = "%volume";
          format_muted = "muted (%volume)";
          mixer = "Master";
          mixer_idx = 0;
          device = "default";
        };
      };
      "disk /" = {
        position = 2;
        settings = {
          format = "/ %avail";
        };
      };
      "ethernet _first_" = {
        position = 3;
        settings = {
          format_up = "E: %ip (%speed)";
          format_down = "E: down";
        };
      };
      "load" = {
        position = 4;
        settings = {
          format = "%1min";
        };
      };
      "battery 0" = {
        position = 5;
        settings = {
          format = "%status %percentage";
          format_down = "no batt.";
          status_chr = "+ --";
          status_bat = "-";
          status_unk = "unk";
          status_full = "! --";
          low_threshold = 10;
          threshold_type = "percentage";
          last_full_capacity = false;
          hide_seconds = true;
          path = "/sys/class/power_supply/BAT1/uevent";
        };
      };
      "time" = {
        position = 6;
        settings = {
          format = "%Y-%m-%d %H:%M:%S";
        };
      };
    };
  };
}
