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

    # datsnvim copies its writable package lock before linkGeneration creates
    # the managed Neovim configuration directory.
    home.activation.ensureDatsnvimConfigDir = lib.hm.dag.entryBefore ["copyDatsnvimLock"] ''
      run mkdir -p "$HOME/.config/nvim"
    '';

    programs.datsnvim.enable = true;
  };
}
