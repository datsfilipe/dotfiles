{
  pkgs,
  lib,
  ...
}:
with lib; let
  lockfile = "vim.fn.expand('$HOME/.dotfiles/home/base/tui/editors/neovim/conf') .. '/lazy-lock.json'";
in {
  programs.datsnvim = {
    enable = true;
    settings = {
      lazy.lock = lockfile;
    };
  };

  home.packages = with pkgs; [
    tree-sitter
    fd
  ];

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
}
