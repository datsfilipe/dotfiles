{ inputs, pkgs, lib, ... }:

let
  theme = (import ../../modules/colorscheme).theme;
in {
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
      "${lib.makeLibraryPath [ pkgs.stdenv.cc.cc pkgs.zlib ]}"
      "--suffix"
      "PKG_CONFIG_PATH"
      ":"
      "${lib.makeSearchPathOutput "dev" "lib/pkgconfig" [ pkgs.stdenv.cc.cc pkgs.zlib ]}"
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
