{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.editors.neovim.system;

  editorScript = pkgs.writeShellScriptBin "nvim-editor" ''
    exec nvim --clean \
      -c 'set clipboard=unnamedplus' \
      -c 'highlight Normal guibg=NONE ctermbg=NONE' \
      "$@"
  '';
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
