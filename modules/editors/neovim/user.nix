{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.editors.neovim.user;
in {
  options.modules.editors.neovim.user.enable = mkEnableOption "Neovim via datsnvim";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      tree-sitter
      fd
    ];

    programs.datsnvim.enable = true;
  };
}
