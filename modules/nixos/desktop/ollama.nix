{
  config,
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
      acceleration = lib.mkIf config.modules.desktop.nvidia.enable "cuda";
    };
  };
}
