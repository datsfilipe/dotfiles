{ lib, pkgs, vars, ... }:

lib.mkIf (vars.environment.desktop == "gnome") {
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome = {
    enable = true;
    extraGSettingsOverrides = ''
      [org.gnome.mutter]
      experimental-features=['scale-monitor-framebuffer']
    '';
  };

  environment.gnome.excludePackages = (with pkgs; [
    gnome-photos
    gnome-tour
    gedit
    cheese
    gedit
    epiphany
    geary
    yelp
  ]);
  environment.systemPackages = with pkgs; [
    gnome-tweaks
    gnome.hitori # sudoku game
  ];
  programs.dconf.enable = true;
}
