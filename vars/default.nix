let
  username = "dtsf";
in {
  username = username;
  userfullname = "Filipe Lima";
  useremail = "datsfilipe.foss@proton.me";
  devenvsPath = "/home/${username}/.dotfiles/modules/devenvs";
  sshAuthorizedKeys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINaF8YTdblaxjJATw1segJGHw69ooLnVY25Vz8hAo9kk datsfilipe.foss@proton.me"
  ];
  wallpaper = "/run/media/dtsf/ext-files/walls/27.png";
}
