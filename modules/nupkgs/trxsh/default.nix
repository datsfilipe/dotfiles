{
  stdenv,
  lib,
  fetchurl,
}: let
  source = builtins.fromJSON (builtins.readFile ./conf/source.json);
in
  stdenv.mkDerivation rec {
    pname = "trxsh";
    version = source.version;

    src = fetchurl {
      url = "https://github.com/datsfilipe/trxsh/releases/download/${version}/trxsh-${version}-linux-amd64.tar.gz";
      sha256 = source.sha256;
    };

    installPhase = ''
      mkdir -p $out/bin
      tar -xzf $src -C $out/bin
      chmod +x $out/bin/trxsh
    '';

    meta = with lib; {
      description = "trxsh is a terminal-based trash manager";
      homepage = "https://github.com/datsfilipe/trxsh";
      license = licenses.mit;
      platforms = ["x86_64-linux"];
    };

    unpackPhase = ":";
    dontStrip = true;
  }
