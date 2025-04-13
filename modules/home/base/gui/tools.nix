{pkgs, ...}: {
  home.packages = with pkgs; [
    beekeeper-studio
  ];
}
