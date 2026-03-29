{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.programs.browsers.user;
in {
  options.modules.programs.browsers.user.enable = mkEnableOption "Browser setup";

  config = mkIf cfg.enable {
    programs.chromium = {
      enable = true;
      package = pkgs.chromium.override {enableWideVine = true;};

      commandLineArgs = [
        "--ozone-platform=wayland"
        "--enable-features=UseOzonePlatform,WaylandWindowDecorations,WebUIDarkMode"
        "--enable-wayland-ime"

        "--use-gl=angle"
        "--use-angle=gl"

        "--enable-features=VaapiVideoDecodeLinuxGL,VaapiVideoDecoder,VaapiOnNvidiaGPUs"
        "--disable-features=UseSkiaGraphite"
        "--disable-gpu-memory-buffer-video-frames"
        "--ignore-gpu-blocklist"

        "--force-dark-mode"
      ];

      dictionaries = [pkgs.hunspellDictsChromium.en_US];
      extensions = [
        {id = "fmkadmapgofadopljbjfkapdkoienihi";} # react devtools
        {id = "nkbihfbeogaeaoehlefnkodbefgpgknn";} # metamask
        {id = "liecbddmkiiihnedobmlmillhodjkdmb";} # loom
        {id = "eimadpbcbfnmbkopoojfekhnkhdbieeh";} # dark reader
        {id = "mgngbgbhliflggkamjnpdmegbkidiapm";} # ytb shorts remover
        {id = "nngceckbapebfimnlniiiahkandclblb";} # bitwarden
      ];
    };
  };
}
