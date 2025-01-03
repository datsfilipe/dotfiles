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

  # xdg.configFile."cava/config".text =
  #   ''
  #     # custom cava config
  #   ''
  #   + builtins.readFile "${nur-ryan4yin.packages.${pkgs.system}.catppuccin-cava}/mocha.cava";

  programs = {
    mpv = {
      enable = true;
      defaultProfiles = ["gpu-hq"];
      scripts = [pkgs.mpvScripts.mpris];
    };
  };

  services = {
    playerctld.enable = true;
  };
}
