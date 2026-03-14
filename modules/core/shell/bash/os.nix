{config, ...}: {
  programs.bash.interactiveShellInit = ''
    export GH_TOKEN="$(get-gh-token)"
    __update_gh_token() {
      export GH_TOKEN="$(get-gh-token)"
    }
    cd() { builtin cd "$@" && __update_gh_token; }
    pushd() { builtin pushd "$@" && __update_gh_token; }
    popd() { builtin popd "$@" && __update_gh_token; }
  '';
}
