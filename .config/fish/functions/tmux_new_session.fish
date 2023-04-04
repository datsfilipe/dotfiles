function tmux_new_session
  set -l current_dir (pwd)
  set -l session_name (basename $current_dir)
  tmux new-session -d -s $session_name

  if test (jobs | wc -l) -gt 0
    disown %1
  end
end
