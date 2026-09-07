{
  pkgs,
  mylib,
  myvars,
  ...
}: {
  imports =
    [
      ./hardware-configuration.nix
      ./boot.nix
      (import ../common/nixos-base.nix {hostName = "dtsf-pc";})
      ../common/custom-certs.nix
    ]
    ++ (mylib.file.scanPaths ../../modules "os.nix");

  modules.hardware.audio.system.enable = true;
  modules.hardware.bluetooth.system.enable = true;
  modules.hardware.nvidia.system.enable = false;
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
  modules.programs.archbox.system.enable = true;
  modules.programs.fhs.system.enable = true;
  modules.programs.games.system.enable = true;
  modules.programs.browsers.system.enable = true;

  systemd.services.pritunl-client = {
    description = "Pritunl Client Service";
    after = ["network.target"];
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      ExecStart = "${pkgs.pritunl-client}/bin/pritunl-client-service";
      Restart = "always";
    };
  };

  system.stateVersion = "26.05";
}
