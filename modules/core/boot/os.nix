{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.core.boot.system;
in {
  options.modules.core.boot.system.enable = mkEnableOption "Base boot and locale configuration";

  config = mkIf cfg.enable {
    boot.loader.systemd-boot = {
      configurationLimit = mkDefault 10;
      consoleMode = mkDefault "max";
    };

    boot.loader.timeout = mkDefault 8;

    zramSwap = {
      enable = true;
      algorithm = "zstd";
      priority = 5;
      memoryPercent = 50;
    };

    time.timeZone = "America/Belem";

    i18n = {
      defaultLocale = "en_US.UTF-8";
      extraLocaleSettings = {
        LC_TIME = "pt_BR.UTF-8";
        LC_MONETARY = "pt_BR.UTF-8";
        LC_MEASUREMENT = "pt_BR.UTF-8";
        LC_PAPER = "pt_BR.UTF-8";
        LC_NAME = "pt_BR.UTF-8";
        LC_ADDRESS = "pt_BR.UTF-8";
        LC_TELEPHONE = "pt_BR.UTF-8";
        LC_NUMERIC = "pt_BR.UTF-8";
        LC_IDENTIFICATION = "pt_BR.UTF-8";
      };
    };

    services = {
      power-profiles-daemon.enable = true;
      upower.enable = true;
    };
  };
}
