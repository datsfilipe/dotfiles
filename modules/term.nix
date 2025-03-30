{
  config,
  lib,
  ...
}:
with lib; {
  options.modules.core.term = {
    default = lib.mkOption {
      type = lib.types.enum ["alacritty" "wezterm" "ghostty" "rio"];
      default = "alacritty";
      description = "Terminal emulator.";
    };
  };

  config = mkMerge [
    (mkIf (config.modules.core.term.default == "alacritty") {
      programs.alacritty.enable = true;
    })

    (mkIf (config.modules.core.term.default == "ghostty") {
      programs.ghostty.enable = true;
    })

    (mkIf (config.modules.core.term.default == "wezterm") {
      programs.wezterm.enable = true;
    })

    (mkIf (config.modules.core.term.default == "rio") {
      programs.rio.enable = true;
    })
  ];
}
