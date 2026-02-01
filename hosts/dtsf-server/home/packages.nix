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

    # Shell alias dependencies
    eza        # Modern ls replacement (for ll, lla, llt aliases)
    bottom     # Modern top replacement (for top, topp aliases)
    unzip      # Archive extraction
    zip
  ]
  ++ (with mypkgs; [
    # Custom packages for shell aliases
    meow       # Custom cat replacement (for cat alias)
    trxsh      # Custom trash management (for del/trash aliases)
    scripts    # Custom scripts (zipper, extract, etc.)
  ]);
}
