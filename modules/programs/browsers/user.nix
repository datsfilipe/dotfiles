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
      package = pkgs-unstable.chromium.override {enableWideVine = true;};

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

      dictionaries = [pkgs-unstable.hunspellDictsChromium.en_US];
      extensions = [
        {id = "fmkadmapgofadopljbjfkapdkoienihi";}
        {id = "liecbddmkiiihnedobmlmillhodjkdmb";}
        {id = "nkbihfbeogaeaoehlefnkodbefgpgknn";}
        {id = "acmacodkjbdgmoleebolmdjonilkdbch";}
        {id = "eimadpbcbfnmbkopoojfekhnkhdbieeh";}
        {id = "dpjamkmjmigaoobjbekmfgabipmfilij";}
      ];
    };
  };
}
