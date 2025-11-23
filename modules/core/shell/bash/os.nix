{config, ...}: {
  programs.bash.interactiveShellInit = ''
    export GH_TOKEN="$(cat ${config.sops.secrets."token/github/dtsf-pc".path})"
  '';
}
