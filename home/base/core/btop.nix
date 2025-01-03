{
  pkgs,
  nur-ryan4yin,
  ...
}: {
  # xdg.configFile."btop/themes".source = "${nur-ryan4yin.packages.${pkgs.system}.catppuccin-btop}/themes";

  programs.btop = {
    enable = true;
    settings = {
      # color_theme = "catppuccin_mocha";
      theme_background = false;
    };
  };
}
