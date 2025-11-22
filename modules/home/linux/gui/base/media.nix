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
    mesa-demos
  ];

  services = {
    playerctld.enable = true;
  };
}
