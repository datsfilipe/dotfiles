{
  pkgs,
  mypkgs,
  ...
}: {
  home.packages = with pkgs; [
    bc
    cloudflared
    mesa
    rnote
    pavucontrol
    brightnessctl
    gnome-tweaks
    gnome-extension-manager
    gnomeExtensions.dash-to-dock
    gnomeExtensions.appindicator
    gnomeExtensions.keyboard-toggle
  ];

  modules.desktop.nupkgs.packages = with mypkgs; [
    scripts
    trxsh
  ];
}
