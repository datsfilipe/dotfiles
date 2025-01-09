{ lib, ghosttypkg, ... }:

with lib; {
  programs.ghostty = {
    enable = false;
    enableFishIntegration = true;
    settings = {
      command = "fish";
      font-size = 14;
      font-family = "JetBrainsMono Nerd Font";
      font-family-bold = "JetBrainsMono Nerd Font Bold";
      font-family-italic = "JetBrainsMono Nerd Font Italic";
      font-family-bold-italic = "JetBrainsMono Nerd Font Bold Italic";
      window-decoration = false;
      bold-is-bright = true;
      auto-update = "off";
      linux-cgroup = "never";
      gtk-single-instance = true;
      window-vsync = false;
      adjust-cursor-thickness = 25;
      window-padding-x = 25;
      window-padding-y = 25;
      window-padding-balance = true;
      gtk-adwaita = false;
      background-opacity = 0.8;
      background-blur-radius = 20;
    };
  };
}
