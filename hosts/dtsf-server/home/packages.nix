{pkgs, ...}: {
  home.packages = with pkgs; [
    htop
    btop
    ripgrep
    fd
    git
    nmap
    dig
    direnv
  ];
}
