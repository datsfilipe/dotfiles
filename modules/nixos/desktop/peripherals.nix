{pkgs, lib, ...}: {
  environment.systemPackages = with pkgs; [
    pulseaudio
  ];

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    wireplumber.enable = true;
  };

  security.rtkit.enable = true;
  hardware.pulseaudio.enable = false;

  options.bluetooth.enable = lib.mkDefault false;
  config = lib.mkIf options.bluetooth.enable {
    hardware.bluetooth.enable = true;
    services.blueman.enable = true;
  };
}
