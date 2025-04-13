{pkgs, ...}: {
  home.packages = with pkgs; [
    udiskie
    libnotify
    inotify-tools
    ventoy
  ];
}
