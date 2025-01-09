{ unix-scripts, myvars, ... }: {
  home.file.".local/bin" = {
    source = "${unix-scripts}";
    recursive = true;
  };

  home.sessionVariables = {
    DEV_ENVS_PATH = "${myvars.devenvsPath}";
  };
}
