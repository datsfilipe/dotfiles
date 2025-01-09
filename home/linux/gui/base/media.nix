{
  pkgs,
  pkgs-unstable,
  ...
}:
{
  home.packages = with pkgs; [
    pavucontrol
    playerctl
    pulsemixer
    feh
    nvtopPackages.full
    cava
    libva-utils
    vdpauinfo
    vulkan-tools
    glxinfo
  ];

  services = {
    playerctld.enable = true;
  };
}
