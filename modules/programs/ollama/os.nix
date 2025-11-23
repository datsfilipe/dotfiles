{
  config,
  pkgs-unstable,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.programs.ollama.system;
in {
  options.modules.programs.ollama.system.enable = mkEnableOption "Ollama";

  config = mkIf cfg.enable {
    services.ollama = {
      enable = true;
      package = pkgs-unstable.ollama;
      acceleration = lib.mkIf config.modules.hardware.nvidia.system.enable "cuda";
      environmentVariables = {
        OLLAMA_LLM_LIBRARY = "cuda";
        LD_LIBRARY_PATH = "run/opengl-driver/lib";
      };
    };
  };
}
