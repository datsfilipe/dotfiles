{
  pkgs,
  mypkgs,
  lib,
  ...
}:
with lib; {
  modules.desktop.nupkgs = {
    programs_datsnvim_lazy_lock = "vim.fn.expand(\"$HOME/.dotfiles/home/base/tui/editors/neovim/conf\") .. \"/lazy-lock.json\"";
  };

  home.packages = with pkgs; [
    vscode-langservers-extracted
    typescript-language-server
    bash-language-server
    lua-language-server
    rust-analyzer
    gopls

    nodePackages.prettier
    codespell
    stylua
    biome

    tree-sitter
    fd
  ];

  xdg.configFile."nvim" = {
    source = mypkgs.datsnvim;
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
}
