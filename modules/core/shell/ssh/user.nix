{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.core.shell.ssh.user;
in {
  options.modules.core.shell.ssh.user.enable = mkEnableOption "User SSH client configuration";

  config = mkIf cfg.enable {
    programs.ssh.enable = true;
  };
}
