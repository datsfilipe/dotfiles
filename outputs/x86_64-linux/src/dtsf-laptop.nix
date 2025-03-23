{
  lib,
  myvars,
  mylib,
  system,
  inputs,
  genSpecialArgs,
  ...
} @ args: let
  name = "dtsf-laptop";
  base-modules = {
    nixos-modules =
      map mylib.file.relativeToRoot [
        "modules/secrets/nixos.nix"
        "modules/wallpaper/nixos.nix"
        "modules/nixos/desktop.nix"
        "hosts/${name}"
      ]
      ++ [
        inputs.sops-nix.nixosModules.sops
      ];
    home-modules =
      map mylib.file.relativeToRoot [
        "home/linux/gui.nix"
        "hosts/${name}/home"
        "modules/nupkgs/home.nix"
        "modules/colorscheme/home.nix"
        "modules/conf/home.nix"
      ]
      ++ [
        inputs.datsnvim.homeManagerModules.${system}.default
      ];
  };

  laptop-modules = {
    nixos-modules =
      [
        {
          modules.desktop.wayland.enable = true;
          modules.ssh-key-manager.enable = true;
          modules.desktop.bluetooth.enable = true;
        }
      ]
      ++ base-modules.nixos-modules;
    home-modules =
      [
        {
          modules.desktop.nupkgs.enable = true;
          modules.desktop.conf = {
            enableCavaIntegration = true;
            enableZellijIntegration = true;
          };
          modules.desktop.colorscheme = {
            enable = true;
            enableNeovimIntegration = true;
            enableAlacrittyIntegration = true;
            enableFishIntegration = true;
            enableCavaIntegration = true;
            enableZellijIntegration = true;
          };
        }
      ]
      ++ base-modules.home-modules;
  };
in {
  nixosConfigurations = {
    "${name}" = mylib.nixosSystem (laptop-modules // args);
  };
}
