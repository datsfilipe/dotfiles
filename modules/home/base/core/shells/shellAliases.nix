{
  "ll" = "eza --color always --icons -1glb -s name --git --sort date --group-directories-first";
  "lla" = "eza --color always --icons -1galb -s name --git --sort date --group-directories-first";
  "tree" = "eza --tree -D -L 3";

  "del" = "trash";
  "dels" = "trash --list";
  "delu" = "trash --fzf";
  "delr" = "trash --restore";
  "delc" = "trash --cleanup";

  "top" = "btop -p 1";
  "topp" = "btop";

  "rm" = "echo \"use trash instead of rm\"";
  "cat" = "bat";
  "zp" = "zipper";
  "ext" = "extract";
  "zj" = "zellij";
  "nsh" = "nix-set-shell";
  "dt" = "devtunnel";
  "dd" = "cd ~/.dotfiles";
  "wconn" = "nmcli-wifi-connect";

  "dc-list" = "docker-helpers names";
  "dc-ips" = "docker-helpers ips";
  "dc-exec" = "docker-helpers ex";
  "dc-log" = "docker-helpers logs";
  "dc-rm" = "docker-helpers srm";
  "dc-rma" = "docker-helpers rall";
  "dc-img-rm" = "docker-helpers riall";
  "dc-stop" = "docker-helpers sall";
  "ne" = "~/.local/bin/nix-env";
}
