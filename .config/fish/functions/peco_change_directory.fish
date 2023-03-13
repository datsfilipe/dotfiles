# use peco to list directories
function _peco_change_directory
  if [ (count $argv) ]
    peco --layout=bottom-up --query "$argv"|perl -pe 's/([ ()])/\\\\$1/g'|read foo
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
  set -l config $HOME/.config
  set -l posts $HOME/www/personal/posts
  set -l notes $HOME/www/personal/notes
  set -l tvim $HOME/.test-config/nvim
  set -l ghq (ghq list -p)
  set -l non_git_dirs (ls -d -- * 2> /dev/null | grep -v '\.git/' | sed 's|/$||')
  set -l media_dirs /run/media/$USER/*

  # combine all directories in an array
  set -l dirs $config $posts $notes $tvim $ghq $media_dirs $non_git_dirs

  # filter out the files
  set -l filtered_dirs
  for dir in $dirs
    if [ -d $dir ]
      switch $dir
        case $notes
          set -l note_dirs (ls -d -- $notes/* 2> /dev/null | sed 's|/$||')
          for note_dir in $note_dirs
            set -l basename (basename $note_dir)
            set filtered_dirs $filtered_dirs $note_dir
          end
        case '*'
          set filtered_dirs $filtered_dirs $dir
      end
    end
  end

  for dir in $filtered_dirs
    echo $dir
  end | _peco_change_directory $argv
end
