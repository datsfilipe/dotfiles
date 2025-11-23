{
  pkgs,
  pkgs-unstable,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.programs.media.user;
in {
  options.modules.programs.media.user.enable = mkEnableOption "Media utilities and mpv setup";

  config = mkIf cfg.enable {
    home.packages = with pkgs;
      [
        ffmpeg-full
        imagemagick
        pavucontrol
        playerctl
        pulsemixer
        nvtopPackages.full
        cava
        libva-utils
        vdpauinfo
        vulkan-tools
        mesa-demos
      ]
      ++ [pkgs-unstable.zoom-us];

    services.playerctld.enable = true;

    programs.mpv = {
      enable = true;
      defaultProfiles = ["gpu-hq"];
      scripts = map (path:
        pkgs.stdenv.mkDerivation {
          pname = "mpv-${builtins.baseNameOf path}";
          version = "1.0";
          src = ./conf;
          installPhase = ''
            mkdir -p $out/share/mpv/scripts
            cp ${builtins.baseNameOf path} $out/share/mpv/scripts/
          '';
          passthru.scriptName = builtins.baseNameOf path;
        }) [./conf/autosave.lua ./conf/notify-send.lua];
    };
  };
}
