{pkgs-unstable, ...}: {
  home.packages = with pkgs-unstable; [
    beekeeper-studio
  ];
}
