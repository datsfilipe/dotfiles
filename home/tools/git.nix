{ lib, ... }:

{
  home.file.".gitconfig".text = ''
    ${lib.fileContents ../../dotfiles/.gitconfig}
  '';
}
