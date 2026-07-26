{
  pkgs,
  mypkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.programs.browsers.user;
  seedFonts = pkgs.writeShellApplication {
    name = "seed-browser-fonts";
    runtimeInputs = [pkgs.jq pkgs.coreutils];
    text = builtins.readFile ./conf/seed-fonts.sh;
  };
in {
  options.modules.programs.browsers.user.enable = mkEnableOption "Browser setup";

  config = mkIf cfg.enable {
    home.packages = [
      (pkgs.brave.override {
        commandLineArgs = concatStringsSep " " [
          "--enable-features=AcceleratedVideoDecodeLinuxGL,AcceleratedVideoEncoder,VaapiOnNvidiaGPUs,WaylandWindowDecorations,WebUIDarkMode"
          "--disable-features=OutdatedBuildDetector,UseChromeOSDirectVideoDecoder,Vulkan"
          "--force-dark-mode"
          "--ignore-gpu-blocklist"
          "--disable-gpu-memory-buffer-video-frames"
          "--no-first-run"
          "--no-default-browser-check"
        ];
      })
      mypkgs.work-browser
    ];

    home.activation.braveFonts = lib.hm.dag.entryAfter ["writeBoundary"] ''
      $DRY_RUN_CMD ${seedFonts}/bin/seed-browser-fonts "$HOME/.config/BraveSoftware/Brave-Browser/Default/Preferences"
    '';
  };
}
