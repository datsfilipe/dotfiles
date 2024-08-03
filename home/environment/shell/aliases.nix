{
  "cat" = "bat";
  "ll"="eza -l -g --icons";
  "lla"="eza -l -a -g --icons";
  "tree"="eza --tree";
  "del"="trash-put";
  "dels"="trash-list";
  "delu"="trash-restore";
  "delc"="trash-empty";
  "delr"="trash-rm";
  "t"="tmux";
  "ta"="tmux attach";
  "rm" = "echo \"Use trash instead of rm\"";
  "g"="git";
  "ga"="git add";
  "gc"="git commit";
  "gca"="git commit --amend";
  "root"="cd \"$(git rev-parse --show-toplevel)\"";
  "main"="git checkout main";
  "top"="btop -p 1";
  "topp"="btop";
  "sg"="ast-grep";
  "dt"="devtunnel";
  # scripts
  "nsh"="nix-set-shell";
  "cr"="curl-request";
  "ext"="extract";
  "zp"="zip";
  "wconn"="nmcli-wifi-connect";
  "vl"="datsvault -l";
  "vn"="datsvault -n";
  "vd"="datsvault -d";
  "vs"="datsvault -s";
  "vu"="datsvault -u";
  "dnames"="docker-helpers names";
  "dips"="docker-helpers ips";
  "dex"="docker-helpers ex";
  "dlogs"="docker-helpers logs";
  "dsrm"="docker-helpers srm";
  "dsall"="docker-helpers sall";
  "drall"="docker-helpers rall";
  "driall"="docker-helpers riall";
  "zj"="zellij";
  "ssha"="eval $(ssh-agent -c) && ssh-add";
  # helpful
  "dd"="cd ~/.dotfiles";
}
