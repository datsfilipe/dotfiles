{colorscheme, ...}: {
  modules.desktop.wms.niri.user.rawConfigValues = [
    ''
      window-rule {
        draw-border-with-background false
      }

      layout {
        gaps 8
        center-focused-column "never"
        preset-column-widths {
          proportion 0.33333
          proportion 0.5
          proportion 0.66667
        }

        default-column-width { proportion 0.5; }

        focus-ring {
          width 4
          active-color "${colorscheme.colors.primary}"
          inactive-color "${colorscheme.colors.altbg}"
        }

        border {
          off
        }

        shadow {
          softness 30
          spread 5
          offset x=0 y=5
          color "${colorscheme.colors.bg}77"
        }

        background-color "${colorscheme.colors.bg}"
      }
    ''
  ];
}
