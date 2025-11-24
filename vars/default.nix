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
  cache = {
    cachix = "datsfilipe-dotfiles";
    publicKeys = [
      "datsfilipe-dotfiles.cachix.org-1:lMJDrZFhAuqQrZXHPxJ/XceIptpJVnr3XNBVKDQHCOE="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    ];
  };
}
