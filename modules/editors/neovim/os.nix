{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.editors.neovim.system;
in {
  options.modules.editors.neovim.system.enable = mkEnableOption "Set EDITOR to neovim";

  config = mkIf cfg.enable {
    environment.variables = {
      EDITOR = "nvim --clean -c 'set clipboard=unnamedplus' -c 'highlight Normal guibg=NONE ctermbg=NONE'";
      MANPAGER = "nvim +Man!";
    };
  };
}
