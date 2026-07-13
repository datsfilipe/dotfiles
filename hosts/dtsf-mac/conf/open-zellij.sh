export PATH="@bin@:/run/current-system/sw/bin:/nix/var/nix/profiles/default/bin:/usr/bin:/bin"
t='dtsf'
s=$(zellij ls -s 2>/dev/null | grep -E "(-|^)$t$" | sort | head -n1)
if [ -n "$s" ]; then
  exec alacritty -e zellij attach "$s"
else
  exec alacritty -e zellij attach -c "$(date +%s)-$t"
fi
