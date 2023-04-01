function tmux_new_session
  tmux new-session -d -s (basename (pwd)) && tmux switch-client -n
end
