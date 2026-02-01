{
  pkgs,
  mypkgs,
  ...
}: {
  home.packages = with pkgs; [
    htop
    btop
    ripgrep
    fd
    git
    nmap
    dig
    direnv
    eza
    bottom
  ]
  ++ (with mypkgs; [
    meow
    trxsh
    scripts
  ]);
}
