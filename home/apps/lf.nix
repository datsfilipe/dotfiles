{ pkgs, ... }:

{
  programs.lf = {
    enable = true;
    keybindings = {
      D = "$trash-put $f";
      H = "cd ~";
      E = "$extract $f";
      i = "$less $f";
      e = "$nvim $f";
    };
    previewer.source = pkgs.writeShellScript "pv.sh" ''
      #!/bin/sh

      MIME=$(file --mime-type -b "$1")

      case "$MIME" in
        *application/x-7z-compressed*)
          7z l "$1";;
        *application/x-tar*)
          tar -tvf "$1";;
        *application/x-compressed-tar*|*application/x-*-compressed-tar*)
          tar -tvf "$1";;
        *application/vnd.rar*)
          7z l "$1";;
        *application/zip*)
          unzip -l "$1";;
        *text/*)
          bat --force-colorization --paging=never --style=changes,numbers \
            --terminal-width $(($2 - 3)) "$1" && false;;
        *)
          echo "No previewer available for $MIME";;
      esac
    '';
  };

  home.packages = with pkgs; [
    file
    p7zip
    unar
    zip
    unzip
  ];
}
