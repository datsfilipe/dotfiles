{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.modules.programs.krita.user;
  conf = "${config.home.homeDirectory}/.dotfiles/modules/programs/krita/conf";
  resources = "${config.home.homeDirectory}/.dotfiles/pkgs/krita-resources/data";
in {
  options.modules.programs.krita.user = {
    enable = lib.mkEnableOption "Krita with shared configuration";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.krita;
      description = "Krita package to install, so hosts can supply their own wrapper.";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [cfg.package];

    xdg.configFile."kritarc".source =
      config.lib.file.mkOutOfStoreSymlink "${conf}/kritarc";

    xdg.configFile."kritashortcutsrc".source =
      config.lib.file.mkOutOfStoreSymlink "${conf}/kritashortcutsrc";

    xdg.dataFile."krita".source =
      config.lib.file.mkOutOfStoreSymlink resources;
  };
}
