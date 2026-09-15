{
  unix-scripts,
  stdenvNoCC,
  makeWrapper,
  zip,
  ...
}:
stdenvNoCC.mkDerivation {
  pname = "unix-scripts";
  version = "unstable";
  src = unix-scripts;

  nativeBuildInputs = [makeWrapper];

  installPhase = ''
    mkdir -p $out/bin $out/libexec
    cp -r ./* $out/bin/
    rm -f $out/bin/LICENSE $out/bin/README.md $out/bin/shared-clipboard

    mv $out/bin/zip $out/libexec/zip
    makeWrapper $out/libexec/zip $out/bin/zip \
      --prefix PATH : ${zip}/bin
  '';
}
