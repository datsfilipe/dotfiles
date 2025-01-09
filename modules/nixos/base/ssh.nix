{
  lib,
  myvars,
  ...
}: {
  networking.firewall.enable = lib.mkDefault false;

  services.openssh = {
    enable = true;
    settings = {
      X11Forwarding = true;
      PermitRootLogin = "prohibit-password";
      PasswordAuthentication = false;
    };
    openFirewall = true;
  };

  environment.enableAllTerminfo = true;
}
