{pkgs, ...}: {
  home.packages = with pkgs; [
    gnupg
    gnumake
    fd
    just
    hyperfine
    nix-index
  ];

  programs = {
    fzf = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
    };

    eza = {
      enable = true;
      git = true;
      icons = "auto";
    };

    bat = {
      enable = false;
      config = {
        pager = "less -FR";
      };
    };

    ripgrep = {
      enable = true;
      package = pkgs.ripgrep.override {withPCRE2 = true;};
      arguments = [
        "--smart-case"
      ];
    };
  };
}
