#!/bin/sh

IS_RUNNING=$(pgrep -f "Shimeji" | wc -l)

if [ $IS_RUNNING -gt 0 ]; then
  pkill -f "Shimeji"
else
  DIR=$PWD
  SHIMEJI_DIR=$HOME/.dotfiles/shells/shimeji/linux-shimeji

  if [ -d "${SHIMEJI_DIR}" ]; then
    cd $SHIMEJI_DIR

    # Load the environment using direnv exec
    direnv exec $SHIMEJI_DIR sh -c '
      direnv allow
      sh ./launch.sh
    '

    cd $DIR
  else
    echo "Shimeji directory not found"
  fi
fi
