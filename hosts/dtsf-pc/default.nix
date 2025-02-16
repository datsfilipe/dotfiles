let
  hostName = "dtsf-pc";
in {
  imports = [
    ./hardware-configuration.nix
    ./boot.nix
  ];

  networking = {
    inherit hostName;
    networkmanager.enable = true;
  };

  system.stateVersion = "25.05";
}
