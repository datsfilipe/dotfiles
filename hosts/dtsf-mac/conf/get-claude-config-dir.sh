case "$PWD" in
/Users/*/org | /Users/*/org/*)
  echo "$HOME/.claude-org"
  ;;
*)
  echo "$HOME/.claude"
  ;;
esac
