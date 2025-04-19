{
  config,
  pkgs,
  lib,
  neovim-nightly,
  ...
}:
with lib; let
  lockfile = "${config.home.homeDirectory}/.dotfiles/modules/home/base/tui/editors/conf/lazy-lock.json";
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
    package = neovim-nightly.packages.${pkgs.system}.default;
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
