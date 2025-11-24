let
  username = "dtsf";
  homedir = "/home/${username}";
  localbin = "${homedir}/.local/bin";
  gobin = "${homedir}/go/bin";
  rustbin = "${homedir}/.cargo/bin";
in {
  username = username;
  userfullname = "Filipe Lima";
  useremail = "datsfilipe.foss@proton.me";
  sshAuthorizedKeys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINaF8YTdblaxjJATw1segJGHw69ooLnVY25Vz8hAo9kk datsfilipe.foss@proton.me"
  ];
  path = "PATH=\"$PATH:${localbin}:${gobin}:${rustbin}\"";
}
