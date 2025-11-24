{
  config,
  lib,
  ...
}:
with lib; {
  options.modules.programs.terminal = {
    default = lib.mkOption {
      type = lib.types.enum ["alacritty" "wezterm" "ghostty" "rio"];
      default = "alacritty";
      description = "Terminal emulator.";
    };
  };

  config = mkMerge [
    (mkIf (config.modules.programs.terminal.default == "alacritty") {
      programs.alacritty.enable = true;
    })

    (mkIf (config.modules.programs.terminal.default == "ghostty") {
      programs.ghostty.enable = true;
    })

    (mkIf (config.modules.programs.terminal.default == "wezterm") {
      programs.wezterm.enable = true;
    })

    (mkIf (config.modules.programs.terminal.default == "rio") {
      programs.rio.enable = true;
    })
  ];
}
