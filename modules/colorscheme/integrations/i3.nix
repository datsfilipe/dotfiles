{
  lib,
  colorscheme,
  pkgs,
  enableI3StatusIntegration,
  ...
}: {
  xsession.windowManager.i3.config = {
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
    bars = [
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
    ];
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
        ${pkgs.dmenu}/bin/dmenu_run -nb "${colorscheme.colors.bg}" \
        -nf "${colorscheme.colors.fg}" \
        -sb "${colorscheme.colors.altbg}" \
        -sf "${colorscheme.colors.fg}"
  '';
  home.file.".local/bin/launcher".executable = true;
}
