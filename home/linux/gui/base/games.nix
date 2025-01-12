{pkgs, ...}: {
  home.packages = with pkgs; [
    steam
    prismlauncher
  ];
}
