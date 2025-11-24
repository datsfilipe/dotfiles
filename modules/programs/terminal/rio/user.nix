{
  pkgs,
  mypkgs,
  lib,
  config,
  ...
}: {
  config = lib.mkIf (config.modules.programs.terminal.default == "rio") {
    programs.rio = {
      package = mypkgs.rio;
      settings = {
        shell.program = "${pkgs.fish}/bin/fish";
        platform.linux.program = "${pkgs.fish}/bin/fish";
        fonts = {
          size = 18;
          hinting = false;
          family = "JetBrainsMono Nerd Font";
          regular = {
            family = "JetBrainsMono Nerd Font";
            style = "Normal";
            width = "Normal";
            weight = 400;
          };
          bold = {
            family = "JetBrainsMono Nerd Font";
            style = "Normal";
            width = "Normal";
            weight = 700;
          };
          italic = {
            family = "JetBrainsMono Nerd Font";
            style = "Italic";
            width = "Normal";
            weight = 400;
          };
          italic-bold = {
            family = "JetBrainsMono Nerd Font";
            style = "Italic";
            width = "Normal";
            weight = 700;
          };
        };
        window = {
          opacity = 0.8;
          blur = true;
          decorations = "Disabled";
        };
        navigation.mode = "Plain";
        line-height = 1.1;
        use-split = false;
        padding-x = 25;
        padding-y = [25 25];
        cursor = {
          shape = "block";
          blinking = true;
          blinking-interval = 500;
        };
      };
    };
  };
}
