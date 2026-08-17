{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.modules.programs.virtualization.user;
in {
  options.modules.programs.virtualization.user.enable =
    mkEnableOption "Docker buildx CLI plugin";

  config = mkIf cfg.enable {
    # Docker discovers CLI plugins from ~/.docker/cli-plugins; register buildx there so
    # `docker buildx` and `docker compose` builds work (the daemon does not bundle it).
    home.file.".docker/cli-plugins/docker-buildx".source = lib.getExe pkgs.docker-buildx;
  };
}
