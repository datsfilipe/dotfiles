{myvars, ...}:
let
  hostName = "dtsf-pc";
in {
  imports = [
    ./hardware-configuration.nix
  ];

  networking = {
    inherit hostName;
    networkmanager.enable = true;
  };

  system.stateVersion = "25.05";
}
