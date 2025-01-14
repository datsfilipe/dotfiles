{
  config,
  lib,
  pkgs,
  mylib,
  datsnvim,
  ...
}: {
  options.modules.desktop.nupkgs = {
    enable = lib.mkEnableOption "NIX User Packages";

    packages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [];
      description = "List of user packages managed via NIX User Packages.";
    };

    programs_datsnvim_theme = lib.mkOption {
      type = lib.types.str;
      default = "default";
    };
    programs_datsnvim_lazy_lock = lib.mkOption {
      type = lib.types.str;
      default = "default";
    };
  };

  config = lib.mkIf config.modules.desktop.nupkgs.enable {
    home.packages =
      config.modules.desktop.nupkgs.packages
      ++ [
        (datsnvim.packages.${pkgs.system}.default.override {
          theme = config.modules.desktop.nupkgs.programs_datsnvim_theme;
          lazy = {lock = config.modules.desktop.nupkgs.programs_datsnvim_lazy_lock;};
        })
      ];
  };
}
