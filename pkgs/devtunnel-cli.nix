{
  stdenv,
  lib,
  fetchurl,
  autoPatchelfHook,
  zlib,
  icu,
  libgcc,
  openssl_1_1,
}:

stdenv.mkDerivation {
  pname = "devtunnel";
  version = "0.2.0";

  src = fetchurl {
    url = "https://aka.ms/TunnelsCliDownload/linux-x64";
    sha256 = "sha256-R89C2vdrgEWhAGQiiCew4cpn5w85QcH6LkyVfHHA/P0=";
  };

  meta = with lib; {
    description = "DevTunnel is a tool that allows you to expose your local development server to the internet";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    platforms = [ "x86_64-linux" ];
  };

  buildInputs = [ autoPatchelfHook zlib stdenv.cc.cc.lib ];
  runtimeDependencies = [ icu openssl_1_1.out ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp $src $out/bin/devtunnel
    chmod +x $out/bin/devtunnel

    runHook postInstall
  '';

  unpackPhase = '':'';
  dontStrip = true;
}
