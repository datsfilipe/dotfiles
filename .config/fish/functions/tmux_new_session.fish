function tmux_new_session
  set -l current_dir (pwd)
  set -l session_name (basename $current_dir)
  set -l config_dir (realpath "$HOME/.config")
  set -l notes_dir (realpath "$HOME/www/personal/notes")
  set -l posts_dir (realpath "$HOME/www/personal/posts")
  set -l ghq (ghq list -p)

  if string match -q "$config_dir/*" "$current_dir";
    or string match -q "$notes_dir/*" "$current_dir";
    or string match -q "$posts_dir/*" "$current_dir";
    or contains $ghq_dirs (pwd)
    bspc desktop -f 3
    alacritty -e tmux new-session -s $session_name &
  else if string match -q $session_name "playlists"
    bspc desktop -f 5
    alacritty -e tmux new-session -s $session_name &
  else
    tmux new-session -d -s $session_name
  end

  if test (tmux list-sessions | wc -l) -gt 1
    tmux switch-client -n
  end

  # this allows the current session to not be associated with the process, so we can detach it
  if test (jobs | wc -l) -gt 0
    disown %1
  end
end
