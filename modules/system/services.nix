{ lib, config, vars, ... }:

{
  services.cron = {
    enable = true;
    systemCronJobs = [
      "* * * * */7 root rm -rf /home/${vars.user}/.local/share/nvim/backup/*"
    ];
  };

  services.ollama = {
    enable = false;
    acceleration = lib.mkIf vars.system.load_nvidia_module "cuda";
    home = "/home/${vars.user}/www/.var/lib/ollama";
    models = "/home/${vars.user}/www/.var/lib/ollama/models";
  };

  systemd.services.ollama = {
    enable = lib.mkIf config.services.ollama.enable true;
    serviceConfig = lib.mkIf config.services.ollama.enable {
      DynamicUser = lib.mkForce false;
    };
  };
}
