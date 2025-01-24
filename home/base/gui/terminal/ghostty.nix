{
  lib,
  mypkgs,
  ...
}:
with lib; {
  programs.ghostty = {
    enable = true;
    package = mypkgs.ghostty;
    enableFishIntegration = true;
    settings = {
      command = "fish";
      font-size = 14;
      font-family = "JetBrainsMono Nerd Font";
      window-decoration = false;
      bold-is-bright = true;
      auto-update = "off";
      window-vsync = false;
      adjust-cursor-thickness = 25;
      window-padding-x = 25;
      window-padding-y = 25;
      window-padding-balance = true;
      gtk-adwaita = false;
      background-opacity = 0.8;
      background-blur-radius = 50;
      scrollback-limit = 100000;
    };
  };
}
