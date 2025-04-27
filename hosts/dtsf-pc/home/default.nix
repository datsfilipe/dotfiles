{
  config,
  pkgs,
  pkgs-unstable,
  mypkgs,
  lib,
  ...
}: {
  imports = [./i3];

  programs.ssh = {
    enable = true;
    extraConfig = ''
      Host github.com
      IdentityFile ~/.ssh/main_key
      IdentitiesOnly yes
      AddKeysToAgent yes
    '';
  };

  home.packages = with pkgs;
    [
      qbittorrent
      slack
      beekeeper-studio
      bitwarden
      pavucontrol
    ]
    ++ [
      pkgs-unstable.zoom-us
    ];

  modules.desktop.nupkgs.packages = with mypkgs; [
    devtunnel-cli
    linux-shimeji
    trxsh
  ];

  modules.desktop.colorscheme.theme = "vesper";
}
