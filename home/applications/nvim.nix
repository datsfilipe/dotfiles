{ inputs, pkgs, lib, theme, ... }:

with lib; {
  xdg.configFile."nvim" = {
    source = inputs.datsnvim;
    recursive = true;
  };

  programs.neovim = {
    enable = true;
    vimAlias = true;
    package = inputs.neovim-nightly-overlay.packages.${pkgs.system}.default;
    extraWrapperArgs = [
      "--suffix"
      "LIBRARY_PATH"
      ":"
      "${makeLibraryPath [ pkgs.stdenv.cc.cc pkgs.zlib ]}"
      "--suffix"
      "PKG_CONFIG_PATH"
      ":"
      "${makeSearchPathOutput "dev" "lib/pkgconfig" [ pkgs.stdenv.cc.cc pkgs.zlib ]}"
    ];
  };

  xdg.configFile."nvim/lua/utils/nix_colorscheme.lua".text = ''
    return "${theme.nvim-colorscheme}"
  '';

  xdg.configFile."nvim/lua/utils/nix_lazylock.lua".text = ''
    return vim.fn.expand("$HOME/.dotfiles/dotfiles/nvim") .. "/lazy-lock.json"
  '';

  home.packages = with pkgs; [ ast-grep ];
}
