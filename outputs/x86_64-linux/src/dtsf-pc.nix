{
  inputs,
  lib,
  myvars,
  mylib,
  system,
  genSpecialArgs,
  ...
} @ args: let
  name = "dtsf-pc";
  base-modules = {
    nixos-modules = map mylib.relativeToRoot [
      "hosts/${name}"
    ];
    home-modules = map mylib.relativeToRoot [
      # "hosts/${name}/home.nix"
    ];
  };

  modules-i3 = {
    nixos-modules = base-modules.nixos-modules;
      # [
      #   {
      #     modules.desktop.xserver.enable = true;
      #   }
      # ]
      # ++ base-modules.nixos-modules;
    home-modules = base-modules.home-modules;
      # [
      #   {modules.desktop.i3.enable = true;}
      # ]
      # ++ base-modules.home-modules;
  };
in {
  nixosConfigurations = {
    "${name}" = mylib.nixosSystem (modules-i3 // args);
  };
}
