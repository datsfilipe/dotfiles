{
  colorscheme,
  mylib,
  ...
}: {
  xdg.configFile."fuzzel/fuzzel.ini".text = ''
    prompt="検索 "
    dpi-aware=no
    font=JetBrainsMono Nerd Font:size=14,Inter:size=14
    icons-enabled=false
    match-mode=fzf
    use-bold=true
    inner-pad=6

    [colors]
    background=${mylib.removeHash colorscheme.colors.bg}dd
    text=${mylib.removeHash colorscheme.colors.fg}ff
    prompt=${mylib.removeHash colorscheme.colors.primary}ff
    placeholder=${mylib.removeHash colorscheme.colors.altbg}ff
    input=${mylib.removeHash colorscheme.colors.fg}ff
    match=${mylib.removeHash colorscheme.colors.red}ff
    selection=${mylib.removeHash colorscheme.colors.altbg}ff
    selection-text=${mylib.removeHash colorscheme.colors.fg}ff
    selection-match=${mylib.removeHash colorscheme.colors.red}ff
    counter=${mylib.removeHash colorscheme.colors.fg}ff
    border=${mylib.removeHash colorscheme.colors.primary}ff

    [border]
    width=4
    radius=6
  '';
}
