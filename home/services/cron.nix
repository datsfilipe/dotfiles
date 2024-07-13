{ vars, ... }:

{
  services.cron = {
    enable = true;
    systemCronJobs = [
      "* * * * */7 root rm -rf /home/${vars.user}/.local/share/nvim/backup/*"
    ];
  };
}
