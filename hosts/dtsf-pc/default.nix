{myvars, ...}:
let
  hostName = "dtsf-pc";
in {
  imports = [];

  networking = {
    inherit hostName;
    networkmanager.enable = true;
  };

  system.stateVersion = "25.05";
}
