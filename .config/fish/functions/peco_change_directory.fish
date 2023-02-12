# use peco to list directories
function _peco_change_directory
  if [ (count $argv) ]
    peco --layout=bottom-up --query "$argv "|perl -pe 's/([ ()])/\\\\$1/g'|read foo
  else
    peco --layout=bottom-up |perl -pe 's/([ ()])/\\\\$1/g'|read foo
  end
  if [ $foo ]
    builtin cd $foo
    commandline -r ''
    commandline -f repaint
  else
    commandline ''
  end
end

function peco_change_directory
  # adding simple dirs to the list
  set dir_list (
    realpath $HOME/.config
    realpath $HOME/www/personal/posts
    realpath $HOME/.test-config/nvim
  )

  # adding ghq list
  for dir in (ghq list -p)
    set dir_list $dir_list $dir
  end

  # adding dirs in $PWD that isn't in git dir
  for dir in (ls -ad */|perl -pe "s#^#$PWD/#"|grep -v \.git)
    set dir_list $dir_list $dir
  end

  # adding home dirs inside www (my projects folder)
  for dir in (find (realpath $HOME/www) -type d | grep -v \.git)
    if test $dir != (realpath $HOME/www)
      set dir_list $dir_list $dir
    end
  end

  # adding mounted drivers dirs
  for dir in (ls -d /run/media/*/*)
    set dir_list $dir_list $dir
  end

  # filtering dirs by existence and non-emptiness
  set dir_list_filtered ( )
  for dir in $dir_list
    if test -d $dir
      if [ (ls -A $dir | wc -l) -gt 0 ]
        set new_dir (echo $dir | sed 's:/*$::') # remove trailling /
        set dir_list_filtered $dir_list_filtered $new_dir
      end
    end
  end

  # pass the list to _peco_change_directory function
  for dir in $dir_list_filtered
    echo $dir
  end | _peco_change_directory $argv
end
