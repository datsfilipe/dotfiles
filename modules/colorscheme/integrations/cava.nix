{ colorscheme, config, lib, mylib, ... }: with mylib; {
  xdg.configFile."cava/config".text = ''
      ${
        format.sections ["color"] {
          color = {
            gradient = 1;
            gradient_color_1 = "${lib.toLower colorscheme.colors.primary}";
            gradient_color_2 = "${color.darkenHex colorscheme.colors.primary 0.1}";
            gradient_color_3 = "${color.darkenHex colorscheme.colors.primary 0.2}";
            gradient_color_4 = "${color.darkenHex colorscheme.colors.primary 0.4}";
            gradient_color_5 = "${color.darkenHex colorscheme.colors.primary 0.5}";
            gradient_color_6 = "${color.darkenHex colorscheme.colors.primary 0.7}";
            gradient_color_7 = "${color.darkenHex colorscheme.colors.primary 0.8}";
            gradient_color_8 = "${color.darkenHex colorscheme.colors.primary 1.0}";
          };
        }
      }
    '';
}
