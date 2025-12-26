{
  "ll" = "eza --color always -1glb -s name --git --sort date --group-directories-first";
  "lla" = "eza --color always -1galb -s name --git --sort date --group-directories-first";
  "llt" = "eza --tree -L 5";

  "del" = "trxsh";
  "dels" = "trxsh --list";
  "delu" = "trxsh --fzf";
  "delr" = "trxsh --restore";
  "delc" = "trxsh --cleanup";

  "trash-put" = "trxsh";
  "trash-empty" = "trxsh --cleanup";
  "trash-list" = "trxsh --list";
  "trash-restore" = "trxsh --restore";

  "top" = "btm -b";
  "topp" = "btm";

  "cat" = "meow";
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
  "nenv" = "nix-envs";
}
