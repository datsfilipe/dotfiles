{ inputs, ... }:

{
  home.file.".local/bin" = {
    source = "${inputs.unix-scripts}";
    recursive = true;
  };
}
