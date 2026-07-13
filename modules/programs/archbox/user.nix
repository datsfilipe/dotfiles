{
  lib,
  mylib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.programs.archbox.user;
  containerName = "arch";
  vars = {"@containerName@" = containerName;};
in {
  options.modules.programs.archbox.user.enable = mkEnableOption "Arch Linux dev container via distrobox";

  config = mkIf cfg.enable {
    programs.distrobox = {
      enable = true;
      settings = {
        container_manager = "docker";
      };
      containers = {
        ${containerName} = {
          image = "docker.io/library/archlinux:latest";
          additional_packages = "base-devel git";
        };
      };
    };

    programs.direnv.stdlib = mylib.file.substitute ./conf/use_arch.sh vars;

    programs.fish.functions = {
      abox = mylib.file.substitute ./conf/abox.fish vars;
    };
  };
}
