{
  appimageTools,
  lib,
  fetchurl,
}: let
  pname = "tableplus";
  source = builtins.fromJSON (builtins.readFile ./conf/source.json);
in
  appimageTools.wrapType2 rec {
    inherit pname;
    version = source.version;

    src = fetchurl {
      url = "https://tableplus.com/release/linux/x64/TablePlus-x64.AppImage";
      sha256 = source.sha256;
    };

    extraInstallCommands = ''
      mkdir -p $out/share/applications
      echo "[Desktop Entry]
      Name=TablePlus
      Exec=$out/bin/${pname}
      Icon=tableplus
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
