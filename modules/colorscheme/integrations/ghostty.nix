{
  config,
  lib,
  colorscheme,
  ...
}: {
  programs.ghostty = {
    settings.theme = "custom";
    themes.custom = {
      background = colorscheme.colors.bg;
      cursor-color = colorscheme.colors.fg;
      foreground = colorscheme.colors.fg;
      palette = [
        "0=${colorscheme.colors.black}"
        "1=${colorscheme.colors.red}"
        "2=${colorscheme.colors.green}"
        "3=${colorscheme.colors.yellow}"
        "4=${colorscheme.colors.blue}"
        "5=${colorscheme.colors.magenta}"
        "6=${colorscheme.colors.cyan}"
        "7=${colorscheme.colors.white}"
        "8=${colorscheme.colors.black}"
        "9=${colorscheme.colors.red}"
        "10=${colorscheme.colors.green}"
        "11=${colorscheme.colors.yellow}"
        "12=${colorscheme.colors.blue}"
        "13=${colorscheme.colors.magenta}"
        "14=${colorscheme.colors.cyan}"
        "15=${colorscheme.colors.fg}"
      ];
      selection-background = colorscheme.colors.bg;
      selection-foreground = colorscheme.colors.bg;
    };
  };
}
