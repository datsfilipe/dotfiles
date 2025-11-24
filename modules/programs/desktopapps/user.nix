{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.programs.desktopapps.user;
in {
  options.modules.programs.desktopapps.user.enable = mkEnableOption "General desktop utilities";

  config = mkIf cfg.enable {
    home.packages = with pkgs;
      [pcmanfm]
      ++ pkgs.lib.optionals config.modules.desktop.wms.sway.user.enable [
        grim
      ]
      ++ pkgs.lib.optionals config.modules.desktop.wms.sway.user.enable [
        (flameshot.overrideAttrs (oldAttrs: {
          src = pkgs.fetchFromGitHub {
            owner = "flameshot-org";
            repo = "flameshot";
            rev = "3d21e4967b68e9ce80fb2238857aa1bf12c7b905";
            sha256 = "sha256-OLRtF/yjHDN+sIbgilBZ6sBZ3FO6K533kFC1L2peugc=";
          };
          cmakeFlags = [
            "-DUSE_WAYLAND_CLIPBOARD=1"
            "-DUSE_WAYLAND_GRIM=1"
          ];
          buildInputs = oldAttrs.buildInputs ++ [pkgs.libsForQt5.kguiaddons];
        }))
      ]
      ++ pkgs.lib.optionals config.modules.desktop.wms.i3.user.enable [
        flameshot
      ];

    fonts.fontconfig.enable = false;
  };
}
