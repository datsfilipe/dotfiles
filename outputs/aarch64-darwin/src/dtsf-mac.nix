{
  lib,
  myvars,
  mylib,
  system,
  inputs,
  genSpecialArgs,
  ...
} @ args: let
  name = "dtsf-mac";
  macVars = myvars // {username = "filipe.lima";};
  specialArgs = genSpecialArgs system // {myvars = macVars;};

  darwin-modules =
    [
      inputs.sops-nix.darwinModules.sops
    ]
    ++ (map mylib.file.relativeToRoot [
      "hosts/${name}"
    ]);

  home-modules =
    [
      inputs.datsnvim.homeManagerModules.default
    ]
    ++ (map mylib.file.relativeToRoot [
      "hosts/${name}/home"
      "pkgs/home.nix"
    ]);
in {
  darwinConfigurations = {
    "${name}" = mylib.darwinSystem (args
      // {
        inherit darwin-modules home-modules specialArgs;
        myvars = macVars;
      });
  };
}
