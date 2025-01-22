{
  config,
  lib,
  pkgs,
  myvars,
  ...
}: {
  programs.git = {
    enable = true;
    lfs.enable = true;

    userName = myvars.userfullname;
    userEmail = myvars.useremail;

    includes = [
      {
        path = "~/work/.gitconfig";
        condition = "gitdir:~/work/";
      }
    ];

    ignores = [
      ".trash"
      ".Trash"
      ".Trash-1000"
    ];

    extraConfig = {
      core.editor = "nvim";
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
      push.default = "simple";
      github.user = "datsfilipe";
      diff.tool = "nvimdiff";
      difftool.nvimdiff.cmd = "nvim -d $LOCAL $REMOTE";
      merge.tool = "nvimdiff1";
      mergetool.nvimdiff.cmd = "nvim -d \"$LOCAL\" \"$REMOTE\" -ancestor \"$BASE\" -merge \"$MERGED\"";
      mergetool.nvimdiff.trustExitCode = true;
      ghq.root = "~/www/s";
      ghq."ssh://git@github.com/d3-inc".root = "~/www/w";

      url = {
        "ssh://git@github.com/datsfilipe" = {
          insteadOf = "https://github.com/datsfilipe";
        };
      };
    };

    aliases = {
      whoami = "!git config user.name";
      br = "branch";
      co = "checkout";
      st = "status -sb";
      sf = "show --name-only";
      rc = "reset --soft HEAD~1";
      r = "reset HEAD --";
      u = "checkout --";
      c = "commit -m";
      ca = "commit -am";
      ps = "push";
      psu = "push -u";
      pl = "pull";
      psm = "!git push origin $(git rev-parse --abbrev-ref HEAD)";
      plm = "!git pull origin $(git rev-parse --abbrev-ref HEAD)";
      lg = "log --graph --name-status --pretty=format:\"%C(red)%h %C(reset)(%cd) %C(green)%an %Creset%s %C(yellow)%d%Creset\" --date=relative";
      chbase = "!f() { git rebase --onto=$1 $2 $(git symbolic-ref --short HEAD); }; f";
      eu = "!f() { git ls-files --unmerged | cut -f2 | sort -u ; }; vim `f`";
      au = "!f() { git ls-files --unmerged | cut -f2 | sort -u ; }; git add `f`";
      incc = "!(git fetch --quiet && git log --pretty=format:'%C(yellow)%h %C(white)- %C(red)%an %C(white)- %C(cyan)%d%Creset %s %C(white)- %ar%Creset' ..@{u})";
      outc = "!(git fetch --quiet && git log --pretty=format:'%C(yellow)%h %C(white)- %C(red)%an %C(white)- %C(cyan)%d%Creset %s %C(white)- %ar%Creset' @{u}..)";

      sp = "submodule update --init --recursive";
      sfor = "submodule foreach";
    };

    hooks = {
      pre-push = ./conf/protected-branchs-hook.sh;
    };
  };

  programs.gh = {
    enable = true;
  };

  home.packages = with pkgs; [
    gitAndTools.ghq
    gitAndTools.git-lfs
  ];

  home.shellAliases = {
    "g" = "git";
    "ga" = "git add";
    "gc" = "git commit";
    "gca" = "git commit --amend";
    "gr" = "reset HEAD --";
    "gu" = "git checkout --";
    "root" = "cd \"$(git rev-parse --show-toplevel)\"";
    "gg" = "BYPASS_HOOKS=true git";
  };
}
