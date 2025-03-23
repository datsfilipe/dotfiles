let
  hostName = "dtsf-laptop";
in {
  imports = [
    ./hardware-configuration.nix
    ./boot.nix
  ];

  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.desktopManager.plasma6.enable = true;

  networking = {
    inherit hostName;
    networkmanager.enable = true;
  };

  system.stateVersion = "25.05";
}
