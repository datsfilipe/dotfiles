{
  lib,
  stdenvNoCC,
  fetchurl,
  makeWrapper,
  jdk21_headless,
}: let
  source = builtins.fromJSON (builtins.readFile ./conf/source.json);
  jdk = jdk21_headless;
in
  stdenvNoCC.mkDerivation (finalAttrs: {
    pname = "suwayomi-server";
    version = source.version;

    src = fetchurl {
      url = "https://github.com/Suwayomi/Suwayomi-Server/releases/download/v${finalAttrs.version}/Suwayomi-Server-v${finalAttrs.version}.jar";
      hash = source.sha256;
    };

    nativeBuildInputs = [makeWrapper];

    dontUnpack = true;

    buildPhase = ''
      runHook preBuild

      makeWrapper ${jdk}/bin/java $out/bin/tachidesk-server \
        --add-flags "-Dsuwayomi.tachidesk.config.server.initialOpenInBrowserEnabled=false -jar $src"

      runHook postBuild
    '';

    meta = with lib; {
      description = "Free and open source manga reader server that runs extensions built for Mihon (Tachiyomi)";
      homepage = "https://github.com/Suwayomi/Suwayomi-Server";
      changelog = "https://github.com/Suwayomi/Suwayomi-Server/releases/tag/v${finalAttrs.version}";
      license = licenses.mpl20;
      platforms = jdk.meta.platforms;
      sourceProvenance = [sourceTypes.binaryBytecode];
      mainProgram = "tachidesk-server";
    };
  })
