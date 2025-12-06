{
  pkgs-unstable,
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
      package = pkgs-unstable.chromium.override {
        enableWideVine = true;
      };
      commandLineArgs = [
        "--ozone-platform=wayland"
        "--enable-features=UseOzonePlatform,WaylandWindowDecorations,WebUIDarkMode,VaapiVideoDecodeLinuxGL,VaapiVideoEncoder"
        "--force-dark-mode"
        "--use-gl=angle"
        "--use-angle=gl"
        "--use-cmd-decoder=passthrough"
        "--enable-gpu-rasterization"
        "--enable-features=RunAllCompositorResourcesBeforeSync"
        "--ignore-gpu-blocklist"
        "--disable-features=UseSkiaGraphite"
      ];
      dictionaries = [pkgs-unstable.hunspellDictsChromium.en_US];
      extensions = [
        {id = "fmkadmapgofadopljbjfkapdkoienihi";} # react devtools
        {id = "liecbddmkiiihnedobmlmillhodjkdmb";} # loom
        {id = "nkbihfbeogaeaoehlefnkodbefgpgknn";} # metamask
        {id = "ojhhcfhabhligodffabdhcaoicecaboo";} # new tab
        {id = "eimadpbcbfnmbkopoojfekhnkhdbieeh";} # dark reader
      ];
    };
  };
}
