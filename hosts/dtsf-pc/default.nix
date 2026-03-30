{
  config,
  lib,
  pkgs,
  mylib,
  myvars,
  ...
}: let
  hostName = "dtsf-pc";
in {
  imports =
    [./hardware-configuration.nix ./boot.nix]
    ++ (mylib.file.scanPaths ../../modules "os.nix");

  networking = {
    inherit hostName;
    networkmanager.enable = true;
  };

  modules.core.boot.system.enable = true;
  modules.core.nix.system.enable = true;
  modules.core.security.system.enable = true;
  modules.core.user.system.enable = true;
  modules.core.system.enable = true;
  modules.core.shell.fish.system.enable = true;
  modules.core.shell.ssh.system.enable = true;
  modules.core.misc.ssh-manager.enable = true;

  modules.hardware.audio.system.enable = true;
  modules.hardware.bluetooth.system.enable = true;
  modules.hardware.nvidia.system.enable = true;
  modules.hardware.monitors = {
    enable = true;
    enableNvidiaSupport = true;
    monitors = myvars.hostsConfig.monitors.pc;
  };

  modules.desktop.displayManager.enable = true;
  modules.desktop.wm.niri.system.enable = true;
  modules.services.gdrive.enable = true;
  modules.desktop.wallpaper = {
    enable = true;
    file = myvars.hostsConfig.wallpaper;
  };

  modules.editors.neovim.system.enable = true;
  modules.desktop.fonts.system.enable = true;

  modules.programs.virtualization.system.enable = true;
  modules.programs.fhs.system.enable = true;
  modules.programs.games.system.enable = true;

  systemd.services.pritunl-client = {
    description = "Pritunl Client Service";
    after = ["network.target"];
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      ExecStart = "${pkgs.pritunl-client}/bin/pritunl-client-service";
      Restart = "always";
    };
  };

  system.activationScripts.custom-certs = lib.stringAfter ["setupSecrets"] ''
    mkdir -p /run/custom-certs
    cat ${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt ${config.sops.secrets."certs/server".path} > /run/custom-certs/ca-bundle.crt

    mkdir -p /home/${myvars.username}/.pki/nssdb
    ${pkgs.nssTools}/bin/certutil -d sql:/home/${myvars.username}/.pki/nssdb -A -t "C,," -n "dtsf-server" -i ${config.sops.secrets."certs/server".path}
    chown -R ${myvars.username}:users /home/${myvars.username}/.pki
  '';

  environment.variables = {
    SSL_CERT_FILE = "/run/custom-certs/ca-bundle.crt";
    NIX_SSL_CERT_FILE = "/run/custom-certs/ca-bundle.crt";
  };

  system.stateVersion = "26.05";
}
