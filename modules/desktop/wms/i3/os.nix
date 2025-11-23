{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.desktop.wms.i3.system;
in {
  options.modules.desktop.wms.i3.system.enable = mkEnableOption "i3 on Xorg";

  config = mkIf cfg.enable {
    services = {
      gvfs.enable = true;

      libinput = {
        enable = true;
        mouse = {
          accelProfile = "flat";
          accelSpeed = "0";
        };
      };

      displayManager.defaultSession = "hm-session";
      xserver = {
        enable = true;
        xkb.layout = "us";
        displayManager.startx.enable = true;

        desktopManager = {
          xterm.enable = false;
          session = [
            {
              name = "hm-session";
              manage = "window";
              start = ''
                ${pkgs.runtimeShell} $HOME/.xsession &
                waitPID=$!
              '';
            }
          ];
        };
      };
    };

    environment.pathsToLink = ["/libexec"];

    modules.desktop.displayManager.enable = mkDefault true;
    modules.desktop.displayManager.sessions.i3 = {
      name = "i3 (Xorg)";
      command = "exec startx";
    };
  };
}
