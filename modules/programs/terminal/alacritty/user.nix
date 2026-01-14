{
  lib,
  config,
  ...
}:
with lib; {
  options.modules.programs.terminal.alacritty = {
    enableDecorations = mkOption {
      type = types.bool;
      default = false;
      description = "Enable window decorations (title bar) for Alacritty";
    };
  };

  config = mkIf (config.modules.programs.terminal.default == "alacritty") {
    programs.alacritty = {
      settings = {
        terminal.shell.program = "fish";

        font = {
          size = 15;
          bold = {
            family = "JetBrainsMono Nerd Font";
            style = "Bold";
          };
          normal = {
            family = "JetBrainsMono Nerd Font";
            style = "Regular";
          };
          italic = {
            family = "JetBrainsMono Nerd Font";
            style = "Italic";
          };
          bold_italic = {
            family = "JetBrainsMono Nerd Font";
            style = "Bold Italic";
          };
        };

        cursor = {
          style = {
            shape = "Block";
            blinking = "On";
          };
          blink_interval = 500;
        };

        keyboard.bindings = [
          {
            key = "Space";
            mods = "Control|Shift";
            action = "None";
          }
        ];

        window = {
          opacity = 0.8;
          padding.x = 25;
          padding.y = 25;
          decorations =
            if config.modules.programs.terminal.alacritty.enableDecorations
            then "full"
            else "none";
        };
      };
    };
  };
}
