{unix-scripts, ...}: {
  home.file.".local/bin" = {
    source = "${unix-scripts}";
    recursive = true;
  };
}
