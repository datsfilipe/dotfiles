{ lib, vars, ... }:

{
  services.cron = {
    enable = true;
    systemCronJobs = [
      "* * * * */7 root rm -rf /home/${vars.user}/.local/share/nvim/backup/*"
    ];
  };

  services.ollama = {
    enable = true;
    acceleration = "cuda";
    home = "/home/${vars.user}/www/.var/lib/ollama";
    models = "/home/${vars.user}/www/.var/lib/ollama/models";
  };

  systemd.services.ollama.serviceConfig.DynamicUser = lib.mkForce false;
}
