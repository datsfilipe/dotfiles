{
  pkgs,
  pkgs-unstable,
  ...
}: {
  home.packages = with pkgs; [
    telegram-desktop
    pcmanfm
    grim
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
  ];

  fonts.fontconfig.enable = false;
}
