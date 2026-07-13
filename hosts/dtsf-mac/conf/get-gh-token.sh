case "$PWD" in
/Users/*/org | /Users/*/org/*)
  cat @orgTokenPath@
  ;;
*)
  cat @tokenPath@
  ;;
esac
