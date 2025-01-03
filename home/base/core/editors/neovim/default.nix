{ neovim-nightly-overlay, pkgs, ... }: {
  programs.neovim = {
    enable = true;
    vimAlias = true;
    package = neovim-nightly-overlay.packages.${pkgs.system}.default;
  };
}
