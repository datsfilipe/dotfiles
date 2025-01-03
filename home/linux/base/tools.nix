{pkgs, ...}: {
  home.packages = with pkgs; [
    libnotify
    ventoy
  ];

  services = {
    udiskie.enable = true;
  };
}
