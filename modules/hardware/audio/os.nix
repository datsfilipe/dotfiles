{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.hardware.audio.system;
in {
  options.modules.hardware.audio.system.enable = mkEnableOption "Audio stack (PipeWire)";

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [pavucontrol];

    services.pulseaudio.enable = false;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
      wireplumber.enable = true;
    };

    security.rtkit.enable = true;
  };
}
