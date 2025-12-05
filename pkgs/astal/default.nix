{
  lib,
  stdenv,
  dart-sass,
  bash,
  astal,
  ags,
  ...
}: 
let
  # We create a custom 'ags' executable that already knows about your libraries.
  # This is the "Nix" equivalent of installing libraries globally for the quick start.
  myAgs = ags.override {
    extraPackages = [
      astal.battery
      astal.wireplumber
      astal.tray
      astal.astal3
      astal.io
    ];
  };
in
stdenv.mkDerivation {
  pname = "bar";
  version = "1.0.0";
  src = ./.;

  buildInputs = [
    myAgs
    dart-sass
  ];

  installPhase = ''
    mkdir -p $out/share/bar
    cp -r . $out/share/bar

    mkdir -p $out/bin
    
    echo "#!${bash}/bin/bash" > $out/bin/bar
    
    echo "export PATH=${lib.makeBinPath [ dart-sass ]}:\$PATH" >> $out/bin/bar
    echo "${myAgs}/bin/ags run $out/share/bar/conf/src/app.ts" >> $out/bin/bar
    
    chmod +x $out/bin/bar
  '';
}
