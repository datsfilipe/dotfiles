{
  lib,
  fetchurl,
  buildFHSEnv,
  jdk21_headless,
}: let
  source = builtins.fromJSON (builtins.readFile ./conf/source.json);
  jdk = jdk21_headless;

  jar = fetchurl {
    url = "https://github.com/Suwayomi/Suwayomi-Server/releases/download/v${source.version}/Suwayomi-Server-v${source.version}.jar";
    hash = source.sha256;
  };
in
  buildFHSEnv {
    name = "suwayomi-server";
    version = source.version;

    runScript = "xvfb-run -a ${jdk}/bin/java -Dsuwayomi.tachidesk.config.server.initialOpenInBrowserEnabled=false -jar ${jar}";

    targetPkgs = pkgs:
      with pkgs; [
        xvfb-run
        glib
        nss
        nspr
        atk
        at-spi2-atk
        at-spi2-core
        cups
        dbus
        expat
        libdrm
        libxkbcommon
        mesa
        libgbm
        libGL
        vulkan-loader
        pciutils
        pango
        cairo
        gtk3
        gdk-pixbuf
        fontconfig
        freetype
        alsa-lib
        libpulseaudio
        libnotify
        nghttp2
        zlib
        systemd
        stdenv.cc.cc.lib
        libx11
        libxcomposite
        libxdamage
        libxext
        libxfixes
        libxrandr
        libxrender
        libxtst
        libxi
        libxcursor
        libxscrnsaver
        libxcb
        libxshmfence
      ];

    meta = with lib; {
      description = "Free and open source manga reader server that runs extensions built for Mihon (Tachiyomi)";
      homepage = "https://github.com/Suwayomi/Suwayomi-Server";
      changelog = "https://github.com/Suwayomi/Suwayomi-Server/releases/tag/v${source.version}";
      license = licenses.mpl20;
      platforms = ["x86_64-linux"];
      sourceProvenance = [sourceTypes.binaryBytecode];
      mainProgram = "suwayomi-server";
    };
  }
