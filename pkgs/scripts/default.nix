{unix-scripts, stdenvNoCC, ...}:
stdenvNoCC.mkDerivation {
  pname = "unix-scripts";
  version = "unstable";
  src = unix-scripts;

  installPhase = ''
    mkdir -p $out/bin
    cp -r ./* $out/bin/
  '';
}
