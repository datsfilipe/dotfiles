{
  colorscheme,
  pkgs,
  ...
}: let
  callscript = pkgs.writeShellScript "i3lock-theme" ''
    BLANK='${colorscheme.colors.bg}00'
    CLEAR='${colorscheme.colors.altbg}22'
    DEFAULT='${colorscheme.colors.altbg}cc'
    TEXT='${colorscheme.colors.fg}ee'
    WRONG='${colorscheme.colors.red}bb'
    VERIFYING='${colorscheme.colors.yellow}bb'

    i3lock \
             --insidever-color=$CLEAR \
             --ringver-color=$VERIFYING \
             \
             --insidewrong-color=$CLEAR \
             --ringwrong-color=$WRONG \
             \
             --inside-color=$BLANK \
             --ring-color=$DEFAULT \
             --line-color=$BLANK \
             --separator-color=$DEFAULT \
             \
             --verif-color=$TEXT \
             --wrong-color=$TEXT \
             --time-color=$TEXT \
             --date-color=$TEXT \
             --layout-color=$TEXT \
             --keyhl-color=$WRONG \
             --bshl-color=$WRONG \
             \
             --screen 1 \
             --blur 5 \
             --clock \
             --indicator \
             --time-str="%H:%M:%S" \
             --date-str="%A, %Y-%m-%d" \
             --keylayout 1 \
  '';
in {
  home.file.".local/bin/i3lock-theme".source = callscript;
  home.file.".local/bin/i3lock-theme".executable = true;
}
