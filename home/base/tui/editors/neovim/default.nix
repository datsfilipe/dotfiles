{
  datsnvim,
  pkgs,
  lib,
  ...
}:
with lib; {
  xdg.configFile."nvim" = {
    source = datsnvim;
    recursive = true;
  };

  programs.neovim = {
    enable = true;
    vimAlias = true;
    extraWrapperArgs = [
      "--suffix"
      "LIBRARY_PATH"
      ":"
      "${makeLibraryPath [pkgs.stdenv.cc.cc pkgs.zlib]}"
      "--suffix"
      "PKG_CONFIG_PATH"
      ":"
      "${makeSearchPathOutput "dev" "lib/pkgconfig" [pkgs.stdenv.cc.cc pkgs.zlib]}"
    ];
  };

  # xdg.configFile."nvim/lua/nix_colorscheme.lua".text = ''
  #   return "${theme.nvim-colorscheme}"
  # '';

  xdg.configFile."nvim/lua/nix_lazylock.lua".text = ''
    return vim.fn.expand("$HOME/.dotfiles/home/base/tui/editors/neovim/conf") .. "/lazy-lock.json"
  '';

  home.packages = with pkgs; [tree-sitter];
}
