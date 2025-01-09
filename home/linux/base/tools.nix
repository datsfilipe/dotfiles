{pkgs, ...}: {
  home.packages = with pkgs; [
    udiskie
    libnotify
    ventoy
  ];
}
