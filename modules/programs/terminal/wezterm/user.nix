{
  lib,
  config,
  ...
}:
with lib; {
  config = mkIf (config.modules.programs.terminal.default == "wezterm") {
    programs.wezterm = {
      extraConfig = ''
        ${fileContents ./conf/wezterm.lua}
      '';
    };
  };
}
