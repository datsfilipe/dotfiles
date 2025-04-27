{
  pkgs,
  pkgs-unstable,
  ...
}: {
  home.packages = with pkgs; [
    pavucontrol
    playerctl
    pulsemixer
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
