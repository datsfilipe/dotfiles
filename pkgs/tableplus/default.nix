{
  appimageTools,
  lib,
  fetchurl,
}: let
  pname = "tableplus";
  source = builtins.fromJSON (builtins.readFile ./conf/source.json);
  version = source.version;

  src = fetchurl {
    url = "https://tableplus.com/release/linux/x64/TablePlus-x64.AppImage";
    sha256 = source.sha256;
  };

  contents = appimageTools.extract {inherit pname version src;};
in
  appimageTools.wrapType2 {
    inherit pname version src;

    extraPkgs = pkgs:
      with pkgs; [
        openssh
        openssl
        hicolor-icon-theme
        adwaita-icon-theme
        reversal-icon-theme
      ];

    extraInstallCommands = ''
      mkdir -p $out/share/applications
      install -Dm444 ${contents}/usr/share/icons/hicolor/256x256/apps/${pname}.png \
        $out/share/icons/hicolor/256x256/apps/${pname}.png
      echo "[Desktop Entry]
      Name=TablePlus
      Exec=$out/bin/${pname}
      Icon=${pname}
      Type=Application
      Categories=Development;Database;" > $out/share/applications/tableplus.desktop
    '';

    meta = with lib; {
      description = "Modern, native tool for database management";
      homepage = "https://tableplus.com/";
      license = licenses.unfree;
      platforms = ["x86_64-linux"];
    };
  }
