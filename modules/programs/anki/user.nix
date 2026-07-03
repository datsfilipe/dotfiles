{
  lib,
  config,
  pkgs,
  ...
}: {
  options.modules.programs.anki.user.enable = lib.mkEnableOption "Anki spaced-repetition (prebuilt binary)";

  config = lib.mkIf config.modules.programs.anki.user.enable {
    home.packages = [pkgs.anki-bin];
  };
}
