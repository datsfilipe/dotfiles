{config, ...}: {
  programs.bash.interactiveShellInit = ''
    export GH_TOKEN="$(get-gh-token)"
    export CLAUDE_CONFIG_DIR="$(get-claude-config-dir)"
    __update_dir_env() {
      export GH_TOKEN="$(get-gh-token)"
      export CLAUDE_CONFIG_DIR="$(get-claude-config-dir)"
    }
    cd() { builtin cd "$@" && __update_dir_env; }
    pushd() { builtin pushd "$@" && __update_dir_env; }
    popd() { builtin popd "$@" && __update_dir_env; }
  '';
}
