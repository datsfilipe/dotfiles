{
  config,
  pkgs-unstable,
  ...
}: let
  shellAliases = import ./aliases.nix;
  localbin = "${config.home.homeDirectory}/.local/bin";
  gobin = "${config.home.homeDirectory}/go/bin";
  rustbin = "${config.home.homeDirectory}/.cargo/bin";
  path = "PATH=\"$PATH:${localbin}:${gobin}:${rustbin}\"";
in {
  imports = [
    (import ./fish.nix { inherit path; })
  ];

  home.shellAliases = shellAliases;
  programs.bash = {
    enable = true;
    enableCompletion = true;
    bashrcExtra = ''
      export ${path}
    '';
  };
}
