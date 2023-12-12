{ pkgs, vars, ... }:

let theme = (import ../../modules/colorscheme).theme;
in {
  xdg.configFile."alacritty/alacritty.yml".text = ''
    shell:
      program: zsh
      args:
        - -l
        - -c
        - "tmux attach || tmux new-session -s dtsf"
    key_bindings:
      - { key: X, mods: Control, action: ToggleViMode }
    font:
      normal:
        family: JetBrainsMono Nerd Font
        style: Regular

      bold:
        family: JetBrainsMono Nerd Font
        style: Bold

      italic:
        family: JetBrainsMono Nerd Font
        style: Italic

      bold_italic:
        family: JetBrainsMono Nerd Font
        style: Bold Italic

      size: 11
    window:
      padding:
        x: 25
        y: 25
      opacity: 0.8
    cursor:
      style: Block
      blink: true
      blink_interval: 500
    import:
      - ~/.config/alacritty/colors.yml
  '';

  xdg.configFile."alacritty/colors.yml".text = ''
    colors:
      primary:
        background: "${theme.scheme.colors.bg}"
        foreground: "${theme.scheme.colors.fg}"

      normal:
        black: "${theme.scheme.colors.black}"
        red: "${theme.scheme.colors.red}"
        green: "${theme.scheme.colors.green}"
        yellow: "${theme.scheme.colors.yellow}"
        blue: "${theme.scheme.colors.blue}"
        magenta: "${theme.scheme.colors.magenta}"
        cyan: "${theme.scheme.colors.cyan}"
        white: "${theme.scheme.colors.white}"

      bright:
        black: "${theme.scheme.colors.black}"
        red: "${theme.scheme.colors.red}"
        green: "${theme.scheme.colors.green}"
        yellow: "${theme.scheme.colors.yellow}"
        blue: "${theme.scheme.colors.blue}"
        magenta: "${theme.scheme.colors.magenta}"
        cyan: "${theme.scheme.colors.cyan}"
        white: "${theme.scheme.colors.white}"
  '';
}
