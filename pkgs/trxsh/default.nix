{
  stdenv,
  lib,
  fetchurl,
}: let
  source = builtins.fromJSON (builtins.readFile ./conf/source.json);
  platformMap = {
    "x86_64-linux" = {
      suffix = "linux-amd64";
      hash = source.sha256;
    };
    "aarch64-darwin" = {
      suffix = "darwin-arm64";
      hash = source.sha256-darwin-arm64 or source.sha256;
    };
  };
  platform = platformMap.${stdenv.hostPlatform.system};
in
  stdenv.mkDerivation rec {
    pname = "trxsh";
    version = source.version;

    src = fetchurl {
      url = "https://github.com/datsfilipe/trxsh/releases/download/${version}/trxsh-${version}-${platform.suffix}.tar.gz";
      sha256 = platform.hash;
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
      platforms = ["x86_64-linux" "aarch64-darwin"];
    };

    unpackPhase = ":";
    dontStrip = true;
  }
