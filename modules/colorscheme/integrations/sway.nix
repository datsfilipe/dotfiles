{
  lib,
  colorscheme,
  pkgs,
  enableI3StatusIntegration,
  enableAstalIntegration,
  ...
}: {
  wayland.windowManager.sway.config = {
    colors = {
      background = colorscheme.colors.bg;
      focused = {
        background = colorscheme.colors.altbg;
        border = colorscheme.colors.altbg;
        childBorder = colorscheme.colors.altbg;
        indicator = colorscheme.colors.altbg;
        text = colorscheme.colors.fg;
      };
      focusedInactive = {
        background = colorscheme.colors.altbg;
        border = colorscheme.colors.bg;
        childBorder = colorscheme.colors.altbg;
        indicator = colorscheme.colors.altbg;
        text = colorscheme.colors.fg;
      };
      unfocused = {
        background = colorscheme.colors.bg;
        border = colorscheme.colors.bg;
        childBorder = colorscheme.colors.bg;
        indicator = colorscheme.colors.bg;
        text = colorscheme.colors.fg;
      };
      urgent = {
        background = colorscheme.colors.red;
        border = colorscheme.colors.red;
        childBorder = colorscheme.colors.red;
        indicator = colorscheme.colors.red;
        text = colorscheme.colors.fg;
      };
    };
    bars =
      if enableI3StatusIntegration
      then [
        {
          id = "bar-0";
          statusCommand = lib.mkIf enableI3StatusIntegration "i3status";
          colors = {
            focusedWorkspace = {
              background = "${colorscheme.colors.altbg}";
              border = "${colorscheme.colors.altbg}cc";
              text = "${colorscheme.colors.fg}";
            };
          };
        }
      ]
      else if enableAstalIntegration
      then [
        {
          id = "bar-0";
          command = "astal";
        }
      ]
      else [];
  };

  programs.i3status = lib.mkIf enableI3StatusIntegration {
    general = {
      color_good = colorscheme.colors.green;
      color_degraded = colorscheme.colors.yellow;
      color_bad = colorscheme.colors.red;
      color_separator = colorscheme.colors.bg;
    };
  };

  home.file.".local/bin/launcher".text = ''
    #!/usr/bin/env bash
        ${pkgs.wmenu}/bin/wmenu-run -p "" \
        -M "${colorscheme.colors.bg}" \
        -m "${colorscheme.colors.fg}" \
        -N "${colorscheme.colors.bg}" \
        -n "${colorscheme.colors.fg}" \
        -S "${colorscheme.colors.bg}" \
        -s "${colorscheme.colors.primary}"
  '';
  home.file.".local/bin/launcher".executable = true;
}
