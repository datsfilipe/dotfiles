{
  fetchurl,
  appimageTools
}:

let
  name = "spacedrive";
  version = "0.1.2";
  src = fetchurl {
    url = "https://github.com/spacedriveapp/spacedrive/releases/download/${version}/Spacedrive-linux-x86_64.AppImage";
    sha256 = "387a0e11f301383d450067093c6a95f803f385b561542da4bca62c02946cd554";
  };
  appimageContents = appimageTools.extractType2 { inherit name src; };
in
appimageTools.wrapType2 {
  inherit name src;

  extraPkgs = pkgs:
    (appimageTools.defaultFhsEnvArgs.multiPkgs pkgs)
    ++ [ pkgs.libthai ];

  extraInstallCommands = ''
      # Installs .desktop files
      install -Dm444 ${appimageContents}/${name}.desktop -t $out/share/applications
      install -Dm444 ${appimageContents}/${name}.png -t $out/share/pixmaps
      substituteInPlace $out/share/applications/${name}.desktop \
        --replace 'Exec=AppRun --no-sandbox %U' 'Exec=${name}'
    '';
}
