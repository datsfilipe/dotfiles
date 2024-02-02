let
  theme = (import ../../modules/colorscheme).theme;
in {
  programs.zathura = {
    enable = true;
    extraConfig = ''
      set selection-clipboard clipboard
      set window-title-home-tilde true
      set statusbar-home-tilde true
      set adjust-open "best-fit"

      set font "JetBrainsMono Nerd Font"

      set adjust-open width
      set recolor true
      set recolor-keephue true
      map <C-Tab> toggle_statusbar
      set guioptions ""

      set recolor-lightcolor rgba(0,0,0,0.2)
      set recolor-darkcolor "${theme.scheme.colors.white}"

      set default-bg rgba(0,0,0,0.4)
      set default-fg "${theme.scheme.colors.white}"
      
      set highlight-active-color "${theme.scheme.colors.bg}"
      set highlight-color "${theme.scheme.colors.white}"
    '';
  };
}
