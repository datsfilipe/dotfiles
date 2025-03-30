{lib, ...}:
with lib; {
  programs.wezterm = {
    extraConfig = ''
      ${fileContents ./conf/wezterm.lua}
    '';
  };
}
