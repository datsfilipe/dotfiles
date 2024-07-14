{ pkgs, ... }:

let
  localPkgs = import ../../../pkgs { pkgs = pkgs; };
in
{
  home.packages = with pkgs; [
    eza
    trash-cli
    zoxide
    file
    p7zip
    unar
    zip
    unzip
  ];

  home.file.".local/bin/fetch".source = "${localPkgs.fetch}/bin/fetch";
  home.file.".config/fetch/conf".source = "${localPkgs.fetch}/confs/simple";
}
