let
  hostName = "dtsf-laptop";
in {
  imports = [
    ./hardware-configuration.nix
    ./boot.nix
  ];

  services.libinput.enable = true;

  networking = {
    inherit hostName;
    networkmanager.enable = true;
  };

  system.stateVersion = "25.05";
}
