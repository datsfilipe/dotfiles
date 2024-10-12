{ vars, ... }:

{
  home.file.".Xresources".text = ''
    *dpi: ${vars.system.dpi}
    Xft.dpi: ${vars.system.dpi}
  '';
}
