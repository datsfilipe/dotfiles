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
  nixos-modules =
    [
      inputs.sops-nix.nixosModules.sops
    ]
    ++ (map mylib.file.relativeToRoot [
      "hosts/${name}"
      "modules/secrets/os.nix"
    ]);

  home-modules =
    [
      inputs.datsnvim.homeManagerModules.${system}.default
    ]
    ++ (map mylib.file.relativeToRoot [
      "hosts/${name}/home"
      "pkgs/home.nix"
    ]);
in {
  nixosConfigurations = {
    "${name}" = mylib.nixosSystem (args // {inherit nixos-modules home-modules;});
  };
}
