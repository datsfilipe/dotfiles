{
  lib,
  config,
  osConfig,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.programs.routine.user;
  scheduleFile = osConfig.sops.secrets."routine".path;

  routineScript = pkgs.writeShellApplication {
    name = "routine-reminder";
    runtimeInputs = [pkgs.coreutils pkgs.libnotify];
    text = builtins.readFile ./conf/routine-reminder.sh;
  };
in {
  options.modules.programs.routine.user.enable = mkEnableOption "Routine bloc reminders via notify-send";

  config = mkIf cfg.enable {
    home.packages = [routineScript];

    systemd.user.services.routine-reminder = {
      Unit.Description = "Routine bloc reminder tick";
      Service = {
        Type = "oneshot";
        Environment = ["ROUTINE_SCHEDULE_FILE=${scheduleFile}"];
        ExecStart = "${routineScript}/bin/routine-reminder tick";
      };
    };

    systemd.user.timers.routine-reminder = {
      Unit.Description = "Routine bloc reminder timer";
      Timer = {
        OnCalendar = "*:0/1";
        AccuracySec = "1s";
        Persistent = false;
      };
      Install.WantedBy = ["timers.target"];
    };

    systemd.user.services.routine-reminder-startup = {
      Unit = {
        Description = "Routine bloc in-progress notice at session start";
        After = ["graphical-session.target"];
        PartOf = ["graphical-session.target"];
      };
      Service = {
        Type = "oneshot";
        Environment = ["ROUTINE_SCHEDULE_FILE=${scheduleFile}"];
        ExecStartPre = "${pkgs.coreutils}/bin/sleep 8";
        ExecStart = "${routineScript}/bin/routine-reminder startup";
      };
      Install.WantedBy = ["graphical-session.target"];
    };
  };
}
