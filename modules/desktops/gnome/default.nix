{ lib, pkgs, vars, ... }:

lib.mkIf (vars.environment.desktop == "gnome") {
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  environment.gnome.excludePackages = (with pkgs; [
    gnome-photos
    gnome-tour
    gedit
    cheese
    gnome-music
    gedit
    epiphany
    geary
    gnome-characters
    tali
    iagno
    hitori
    atomix
    yelp
    gnome-contacts
    gnome-initial-setup
  ]);
  programs.dconf.enable = true;
  environment.systemPackages = with pkgs; [
    gnome-tweaks
    hitori # sudoku game
  ];
}
