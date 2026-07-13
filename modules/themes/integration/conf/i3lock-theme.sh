BLANK='@bg@00'
CLEAR='@altbg@22'
DEFAULT='@altbg@cc'
TEXT='@fg@ee'
WRONG='@red@bb'
VERIFYING='@yellow@bb'

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
  --keylayout 1
