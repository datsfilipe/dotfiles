{
  config,
  pkgs,
  mypkgs,
  lib,
  ...
}: let
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
        keybindings = keymaps.allBindings;

        startup = [
          (lib.mkIf (config.modules.shared.multi-monitors.enableNvidiaSupport) (
            command "nvidia-settings --assign CurrentMetaMode=\"${buildMetaMode config.modules.shared.multi-monitors.monitors}\"" false
          ))
          (command "udiskie --tray --notify" false)
          (command "${msgCmd} 'workspace 1'" false)
          (command "dunst -config ${config.home.homeDirectory}/.config/dunstrc" false)
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
  imports = [./packages.nix];

  modules.desktop.colorscheme.theme = "gruvbox";

  modules.desktop = {
    sway = generate "sway";
    i3 = generate "i3";
  };

  programs.ssh = {
    enable = true;
    extraConfig = ''
      Host github.com
      IdentityFile ~/.ssh/main_key
      IdentitiesOnly yes
      AddKeysToAgent yes
    '';
  };

  modules.desktop.nupkgs.packages = with mypkgs;
    lib.mkIf (config.modules.desktop.sway.enable) [
      astal
    ];
}
