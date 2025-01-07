{
  config,
  pkgs,
  ...
}: {
  security.polkit.enable = true;
  programs.gnupg.agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-gtk2;
    enableSSHSupport = false;
    settings.default-cache-ttl = 4 * 60 * 60;
  };
}
