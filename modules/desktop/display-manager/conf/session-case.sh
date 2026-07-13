if [ "$choice" = "@name@" ]; then
  cmd='@command@'
  case "$cmd" in
  exec\ *) eval "$cmd" ;;
  *) exec @shell@ -l -c "$cmd" ;;
  esac
fi
