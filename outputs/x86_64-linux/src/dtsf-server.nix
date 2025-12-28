{
  lib,
  myvars,
  mylib,
  system,
  inputs,
  ...
} @ args: let
  name = "dtsf-server";

  nixos-modules =
    [
      inputs.sops-nix.nixosModules.sops
    ]
    ++ (map mylib.file.relativeToRoot [
      "hosts/${name}"
      "modules/secrets/os.nix"

      "modules/core/boot/os.nix"
      "modules/core/nix/os.nix"
      "modules/core/security/os.nix"
      "modules/core/system/os.nix"
      "modules/core/user/os.nix"
      "modules/core/shell/bash/os.nix"
      "modules/core/shell/fish/os.nix"

      "modules/core/misc/ssh-manager/os.nix"
      "modules/core/shell/ssh/os.nix"
    ]);

  home-modules =
    [
      inputs.datsnvim.homeManagerModules.default
    ]
    ++ (map mylib.file.relativeToRoot [
      "hosts/${name}/home"
      "pkgs/home.nix"

      "modules/core/shell/bash/user.nix"
      "modules/core/shell/fish/user.nix"
      "modules/editors/neovim/user.nix"
    ]);
in {
  nixosConfigurations = {
    "${name}" = mylib.nixosSystem (args // {inherit nixos-modules home-modules;});
  };
}
