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
    nixos-modules = map mylib.relativeToRoot [
      "secrets/nixos.nix"
      "modules/nixos/desktop.nix"
      "hosts/${name}"
    ] ++ [
      inputs.sops-nix.nixosModules.sops
    ];
    home-modules = map mylib.relativeToRoot [
      "home/linux/gui.nix"
      "hosts/${name}/home"
    ];
  };

  modules-i3 = {
    nixos-modules =
      [
        {
          modules.desktop.xorg.enable = true;
          modules.desktop.nvidia.enable = true;
          modules.ssh-key-manager.enable = true;
        }
      ]
      ++ base-modules.nixos-modules;
    home-modules =
      [
        {modules.desktop.i3.enable = true;}
      ]
      ++ base-modules.home-modules;
  };
in {
  nixosConfigurations = {
    "${name}" = mylib.nixosSystem (modules-i3 // args);
  };
}
