{
  lib,
  myvars,
  mylib,
  system,
  inputs,
  genSpecialArgs,
  ...
} @ args: let
  name = "dtsf-pc";
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

  modules-sway = {
    nixos-modules =
      [
        {
          modules.desktop.wayland.enable = true;
          modules.desktop.wallpaper.enable = true;
          modules.desktop.nvidia.enable = true;
          modules.ssh-key-manager.enable = true;
        }
      ]
      ++ base-modules.nixos-modules;
    home-modules =
      [
        {
          modules.desktop.sway.enable = true;
          modules.desktop.nupkgs.enable = true;
          modules.desktop.conf = {
            enableDunstIntegration = true;
            enableCavaIntegration = true;
            enableZellijIntegration = true;
            enablePicomIntegration = true;
          };
          modules.desktop.colorscheme = {
            enable = true;
            enableNeovimIntegration = true;
            enableGTKIntegration = true;
            enableSwayIntegration = true;
            enableI3StatusIntegration = false;
            enableDunstIntegration = true;
            enableAlacrittyIntegration = true;
            enableFishIntegration = true;
            enableCavaIntegration = true;
            enableZellijIntegration = true;
            enableGhosttyIntegration = false;
            enableAstalIntegration = true;
          };
        }
      ]
      ++ base-modules.home-modules;
  };
in {
  nixosConfigurations = {
    "${name}" = mylib.nixosSystem (modules-sway // args);
  };
}
