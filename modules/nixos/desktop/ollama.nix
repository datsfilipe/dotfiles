{
  config,
  pkgs-unstable,
  lib,
  ...
}:
with lib; {
  options.modules.desktop.ollama = {
    enable = mkEnableOption "Ollama";
  };

  config = mkIf config.modules.desktop.ollama.enable {
    services.ollama = {
      enable = true;
      package = pkgs-unstable.ollama;
      acceleration = lib.mkIf config.modules.desktop.nvidia.enable "cuda";
      environmentVariables = {
        OLLAMA_LLM_LIBRARY = "cuda";
        LD_LIBRARY_PATH = "run/opengl-driver/lib";
      };
    };
  };
}
