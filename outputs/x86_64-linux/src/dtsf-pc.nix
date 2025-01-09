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
    nixos-modules = map mylib.file.relativeToRoot [
      "modules/secrets/nixos.nix"
      "modules/wallpaper/nixos.nix"
      "modules/nixos/desktop.nix"
      "hosts/${name}"
    ] ++ [
      inputs.sops-nix.nixosModules.sops
    ];
    home-modules = map mylib.file.relativeToRoot [
      "home/linux/gui.nix"
      "hosts/${name}/home"
      "modules/nupkgs/home.nix"
      "modules/colorscheme/home.nix"
      "modules/conf/home.nix"
    ];
  };

  modules-i3 = {
    nixos-modules =
      [
        {
          modules.desktop.xorg.enable = true;
          modules.desktop.wallpaper.enable = true;
          modules.desktop.nvidia.enable = true;
          modules.ssh-key-manager.enable = true;
        }
      ]
      ++ base-modules.nixos-modules;
    home-modules =
      [
        {
          modules.desktop.i3.enable = true;
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
            enableI3Integration = true;
            enableI3LockIntegration = true;
            enableI3StatusIntegration = true;
            enableDunstIntegration = true;
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
    "${name}" = mylib.nixosSystem (modules-i3 // args);
  };
}
