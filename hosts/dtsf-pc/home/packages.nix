{ ... }: {
  programs.i3status = {
    enable = true;
    modules = {
      "volume master" = {
        position = 1;
        settings = {
          format = "%volume";
          format_muted = "X (%volume)";
          device = "pulse:1";
        };
      };
      "disk /" = {
        position = 2;
        settings = {
          format = "/ %avail";
        };
      };
      wireless = {
        position = 3;
        settings = {
          format = "W: (%quality at %essid) %ip";
          format_down = "W: down";
        };
      };
      load = {
        position = 4;
        settings = {
          format = "%1min";
        };
      };
      battery = {
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
      tztime = {
        position = 6;
        settings = {
          format = "%Y-%m-%d %H:%M:%S";
        };
      };
    };
  };
}
