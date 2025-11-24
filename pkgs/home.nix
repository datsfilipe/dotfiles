{
  config,
  lib,
  pkgs,
  mylib,
  ...
}: {
  options.modules.desktop.nupkgs = {
    enable = lib.mkEnableOption "NIX User Packages";

    packages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [];
      description = "List of user packages managed via NIX User Packages.";
    };
  };

  config = lib.mkIf config.modules.desktop.nupkgs.enable {
    home.packages = config.modules.desktop.nupkgs.packages;
  };
}
