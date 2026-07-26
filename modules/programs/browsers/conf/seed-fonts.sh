prefs="$1"

mkdir -p "$(dirname "$prefs")"
if [ ! -f "$prefs" ]; then
  printf '{}' >"$prefs"
fi

tmp="$(mktemp)"
jq '
  .webkit.webprefs.fonts.standard.Zyyy = "Inter"
  | .webkit.webprefs.fonts.serif.Zyyy = "Inter"
  | .webkit.webprefs.fonts.sansserif.Zyyy = "Inter"
  | .webkit.webprefs.fonts.fixed.Zyyy = "JetBrainsMono Nerd Font"
' "$prefs" >"$tmp"
mv "$tmp" "$prefs"
