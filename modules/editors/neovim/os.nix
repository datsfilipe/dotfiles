{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.editors.neovim.system;

  editorScript = pkgs.writeShellScriptBin "nvim-editor" (builtins.readFile ./conf/nvim-editor.sh);
in {
  options.modules.editors.neovim.system.enable = mkEnableOption "Set EDITOR to neovim";

  config = mkIf cfg.enable {
    environment.systemPackages = [editorScript];

    environment.variables = {
      EDITOR = "nvim-editor";
      MANPAGER = "nvim +Man!";
    };
  };
}
