set -eu
IFS=$'\n\t'
options=(@sessionOptions@)
if ! command -v @gum@ >/dev/null 2>&1; then
  echo "gum not installed. Falling back to first session."
  @fallback@
fi
choice=$(@gum@ choose --header "Select a GUI session" "Shell" @sessionOptions@)
if [ "$choice" = "Shell" ]; then
  exec @shell@ -l
fi

@cases@

exit 1
