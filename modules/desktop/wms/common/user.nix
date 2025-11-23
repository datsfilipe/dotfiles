{
  config,
  pkgs,
  mypkgs,
  lib,
  ...
}: {
  options.modules.desktop.wms.common = {
    enable = lib.mkEnableOption "i3 and sway common configuration";
  };

  config = lib.mkIf config.modules.desktop.wms.common.enable (
    let
      generate = wm: let
        mod = "Mod4";
        alt = "Mod1";
        msgCmd =
          if wm == "sway"
          then "swaymsg"
          else "i3-msg";
        keymaps = import ./keymaps.nix {inherit mod alt pkgs mypkgs lib config;};

        buildMetaMode = monitors:
          lib.concatStringsSep ", " (map (
              m: let
                name = m.name;
                mode = "${m.resolution}_${toString m.refreshRate}";
                pos = "+${toString m.nvidiaSettings.coordinate.x}+${toString m.nvidiaSettings.coordinate.y}";
                flags = [
                  (
                    if m.nvidiaSettings.rotation != null
                    then "rotation=${m.nvidiaSettings.rotation}"
                    else null
                  )
                  (
                    if m.nvidiaSettings.forceFullCompositionPipeline
                    then "ForceFullCompositionPipeline=On"
                    else null
                  )
                ];
                filteredFlags = builtins.filter (x: x != null) flags;
                flagString =
                  if builtins.length filteredFlags > 0
                  then " {${lib.concatStringsSep ", " filteredFlags}}"
                  else "";
              in "${name}: ${mode} ${pos}${flagString}"
            )
            monitors);

        command = str: always: {
          command = str;
          always = always;
        };
      in {
        settings = lib.mkMerge [
          {
            modifier = mod;
            focus.followMouse = false;
            focus.wrapping = "workspace";
            keybindings = keymaps.allBindings;

            startup = [
              (lib.mkIf (config.modules.hardware.monitors.enableNvidiaSupport) (
                command "nvidia-settings --assign CurrentMetaMode=\"${buildMetaMode config.modules.hardware.monitors.monitors}\"" false
              ))
              (command "udiskie --tray --notify" false)
              (command "${msgCmd} 'workspace 1'" false)
              (command "dunst -config ${config.home.homeDirectory}/.config/dunst/dunstrc" false)
              (command "flameshot & disown" false)
              (lib.mkIf (wm == "sway") (command "systemctl --user start wallpaper.service" false))
            ];

            modes = {
              resize = {
                h = "resize shrink width 10 px or 10 ppt";
                j = "resize grow height 10 px or 10 ppt";
                k = "resize shrink height 10 px or 10 ppt";
                l = "resize grow width 10 px or 10 ppt";

                Left = "resize shrink width 10 px or 10 ppt";
                Down = "resize grow height 10 px or 10 ppt";
                Up = "resize shrink height 10 px or 10 ppt";
                Right = "resize grow width 10 px or 10 ppt";

                Return = "mode default";
                Escape = "mode default";
                "${mod}+r" = "mode default";
              };
            };

            workspaceOutputAssign =
              (map (i: {
                workspace = "${toString i}";
                output = "DP-0";
              }) (lib.range 1 7))
              ++ (map (i: {
                workspace = "${toString i}";
                output = "HDMI-0";
              }) (lib.range 8 10));

            fonts = {
              names = ["JetBrainsMono Nerd Font"];
              style = "Regular";
              size = 8.0;
            };

            window.titlebar = true;
            window.commands = [
              {
                command = "floating enable, sticky enable";
                criteria = {title = "^win";};
              }
            ];
          }

          (lib.mkIf (wm == "sway") {
            input = {
              "1133:16500:Logitech_G305" = {
                accel_profile = "flat";
                pointer_accel = "0";
              };

              "type:keyboard" = {
                xkb_layout = "us";
                xkb_variant = "altgr-intl";
                xkb_options = "compose:menu,level3:ralt_switch,grp:win_space_toggle";
              };
            };
          })
        ];
      };
    in {
      modules.desktop.wms = {
        sway.user.settings = (generate "sway").settings;
        i3.user.settings = (generate "i3").settings;
      };

      programs.i3status = lib.mkIf (config.modules.desktop.wms.i3.user.enable) {
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
  );
}
