{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.programs.notes.user;

  notesScript = pkgs.writeShellApplication {
    name = "notes-autocommit";
    runtimeInputs = [pkgs.coreutils pkgs.git pkgs.openssh];
    text = builtins.readFile ./conf/notes-autocommit.sh;
  };

  environment = [
    "NOTES_DIR=${cfg.path}"
    "NOTES_REMOTE=${cfg.remote}"
  ];

  workspaceEntry = {
    _type = "gvariant";
    type = "(aysus)";
    value = null;
    __toString = _: "(b'${cfg.path}/', 'folder-symbolic', 442479871, 'notes')";
  };
in {
  options.modules.programs.notes.user = {
    enable = mkEnableOption "Study notes repo with hourly autocommit";

    path = mkOption {
      type = types.str;
      default = "${config.home.homeDirectory}/.notes";
      description = "Where the notes repo lives (outside the dotfiles).";
    };

    remote = mkOption {
      type = types.str;
      default = "git@github.com:datsfilipe/study-notes.git";
      description = "Git remote to clone from and push to.";
    };

    rnote = mkOption {
      type = types.bool;
      default = true;
      description = "Install rnote and pin its default workspace to the notes dir.";
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      home.packages = [notesScript];

      systemd.user.services.notes-autocommit = {
        Unit.Description = "Autocommit study notes";
        Service = {
          Type = "oneshot";
          Environment = environment;
          ExecStart = "${notesScript}/bin/notes-autocommit";
        };
      };

      systemd.user.timers.notes-autocommit = {
        Unit.Description = "Hourly study notes autocommit timer";
        Timer = {
          OnCalendar = "hourly";
          Persistent = true;
        };
        Install.WantedBy = ["timers.target"];
      };

      systemd.user.services.notes-clone = {
        Unit = {
          Description = "Clone study notes repo at session start";
          After = ["graphical-session.target"];
          PartOf = ["graphical-session.target"];
        };
        Service = {
          Type = "oneshot";
          Environment = environment;
          ExecStartPre = "${pkgs.coreutils}/bin/sleep 8";
          ExecStart = "${notesScript}/bin/notes-autocommit";
        };
        Install.WantedBy = ["graphical-session.target"];
      };
    }

    (mkIf cfg.rnote {
      home.packages = [pkgs.rnote];

      dconf.settings."com/github/flxzt/rnote" = {
        workspace-list = [workspaceEntry];
        selected-workspace-index = lib.hm.gvariant.mkUint32 0;
      };
    })
  ]);
}
