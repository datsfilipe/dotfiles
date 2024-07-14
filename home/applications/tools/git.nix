{ lib, ... }:

with lib; {
  home.file.".gitconfig".text = ''
    ${fileContents ../../../dotfiles/.gitconfig}
  '';
}
