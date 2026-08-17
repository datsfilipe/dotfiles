{config, ...}: {
  programs.bash.interactiveShellInit = ''
    export CLAUDE_CONFIG_DIR="$HOME/.claude-org"
    export GH_TOKEN="$(get-gh-token)"
    __update_dir_env() {
      export GH_TOKEN="$(get-gh-token)"
    }
    cd() { builtin cd "$@" && __update_dir_env; }
    pushd() { builtin pushd "$@" && __update_dir_env; }
    popd() { builtin popd "$@" && __update_dir_env; }
  '';
}
