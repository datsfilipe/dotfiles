{
  config,
  pkgs,
  myvars,
  ...
}: {
  sops = {
    age.generateKey = false;
    age.sshKeyPaths = ["/home/${myvars.username}/.ssh/alt_key"];
    age.keyFile = "/home/${myvars.username}/.config/sops/age/keys.txt";
    defaultSopsFile = ./secrets.yaml;
    defaultSopsFormat = "yaml";
    secrets."ssh/pass/primary" = {
      owner = myvars.username;
    };
    secrets."ssh/remotes" = {
      owner = myvars.username;
    };
    secrets."token/github/dtsf-pc" = {
      owner = myvars.username;
    };
    secrets."hosts" = {
      owner = myvars.username;
    };
  };
}
