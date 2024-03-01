{ stdenv, lib, fetchFromGitHub }:

stdenv.mkDerivation {
  name = "fetch-bin";
  src = fetchFromGitHub {
    owner = "Manas140";
    repo = "fetch";
    rev = "4fc114ed332245b2415ddd007be50e412aaa0cb5";
    sha256 = "sha256-9yB1ur1yVe0qHsACcofdsGGbf+cZsYTgqnNc/IWS/4A=";
  };

  meta = with lib; {
    description = "A simple fetch tool";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    platforms = [ "x86_64-linux" ];
  };

  phases = "installPhase";
  installPhase = ''
    mkdir -p $out/{bin,confs}
    cp $src/fetch $out/bin
    cp $src/conf/* $out/confs
  '';
}
