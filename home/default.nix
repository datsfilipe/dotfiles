{
  inputs,
  nixpkgs,
  vars,
  home-manager,
  ...
}: let
  system = "x86_64-linux";
  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true;
  };

  lib = nixpkgs.lib;
in {
  dtsf-machine = home-manager.lib.homeManagerConfiguration {
    inherit system;
    inherit pkgs;
    extraSpecialArgs = { inherit inputs user; };
    modules = [
      {
        home = {
        username = "${user}";
        homeDirectory = "/home/${user}";
        packages = [ pkgs.home-manager ];
        stateVersion = "23.11";
      };
    ];
  };
}
