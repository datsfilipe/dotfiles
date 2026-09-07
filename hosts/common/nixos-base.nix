{hostName}: {
  lib,
  pkgs,
  ...
}: {
  networking = {
    inherit hostName;
    networkmanager.enable = true;
  };

  users.defaultUserShell = lib.mkForce pkgs.fish;

  modules.core.boot.system.enable = true;
  modules.core.nix.system.enable = true;
  modules.core.security.system.enable = true;
  modules.core.user.system.enable = true;
  modules.core.system.enable = true;
  modules.core.shell.fish.system.enable = true;
  modules.core.shell.ssh.system.enable = true;
  modules.core.misc.ssh-manager.enable = true;
}
