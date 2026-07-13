{
  config,
  pkgs,
  pkgs-unstable,
  mypkgs,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    claude-code
    bc
  ];

  # datsnvim hardcodes neovim-nightly, which can't be cached for this mac (the
  # overlay follows our nixpkgs, so it never matches nix-community's cache) and
  # whose source build fails on crates.io's 403 during cargo vendoring. Keep all
  # of datsnvim's config but use stable neovim from nixpkgs (prebuilt on
  # cache.nixos.org). home-manager's programs.neovim.package wants the unwrapped
  # package, matching the nightly overlay's default output.
  programs.neovim.package = lib.mkForce pkgs.neovim-unwrapped;

  modules.desktop.nupkgs.packages = with mypkgs; [
    trxsh
    scripts
  ];
}
