{ lib, pkgs, config, mylib, ... }:

let
  defaultSettings = import ./default-settings.nix;
  evaluatedSettings = config.modules.desktop.i3.dunst.settings {};
  mergedSettings = lib.recursiveUpdate
    (defaultSettings)
    (evaluatedSettings);
in {
  options.modules.desktop.i3.dunst = {
    enable = lib.mkEnableOption "Whether to enable dunst";

    settings = lib.mkOption {
      type = lib.types.attrsOf lib.types.anything;
      default = defaultSettings;
      apply = lib.recursiveUpdate;
    };
  };

  config = lib.mkIf config.modules.desktop.i3.dunst.enable {
    xdg.configFile."dunstrc".text = builtins.replaceStrings ["'"] ["\""] ''
      ${mylib.format.sections ["global" "urgency_low" "urgency_normal" "urgency_critical"] mergedSettings}
    '';
  };
}
