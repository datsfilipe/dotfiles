{ stdenv
, lib
, fetchurl
, curl
, autoPatchelfHook
, zlib
, icu
, libgcc
, openssl_1_1
}:

let
  platform =
    if stdenv.hostPlatform.system == "x86_64-linux"
    then stdenv.hostPlatform
    else throw "Unsupported system";
  source = builtins.fromJSON (builtins.readFile ./conf/source.json);
in
stdenv.mkDerivation rec {
  pname = "devtunnel";
  name = "devtunnel-cli";
  version = source.version;

  src = fetchurl {
    url = "https://aka.ms/TunnelsCliDownload/linux-x64";
    sha256 = source.sha256;
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

  unpackPhase = ":" ;
  dontStrip = true;
}
