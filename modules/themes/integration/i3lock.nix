{
  colorscheme,
  pkgs,
  ...
}: let
  callscript = pkgs.writeShellScript "i3lock-theme" (builtins.replaceStrings
    ["@bg@" "@altbg@" "@fg@" "@red@" "@yellow@"]
    (with colorscheme.colors; [bg altbg fg red yellow])
    (builtins.readFile ./conf/i3lock-theme.sh));
in {
  home.file.".local/bin/i3lock-theme".source = callscript;
  home.file.".local/bin/i3lock-theme".executable = true;
}
