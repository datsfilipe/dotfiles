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
  environment.systemPackages = with pkgs; [
    gnome-tweaks
    hitori # sudoku game
  ];

  programs.dconf.enable = true;
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
    "org/gnome/desktop/background" = {
      picture-uri = "file:///home/${vars.user}/.config/wallpaper.png";
    };
  };

  home.file.".Xresources".text = ''
    *dpi: ${vars.system.dpi}
    Xft.dpi: ${vars.system.dpi}
  '';
}
