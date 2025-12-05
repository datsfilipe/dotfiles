{
  lib,
  stdenv,
  dart-sass,
  bash,
  astal,
  ags,
  ...
}: let
  myAgs = ags.override {
    extraPackages = [
      astal.battery
      astal.wireplumber
      astal.tray
      astal.astal3
      astal.io
      astal.apps
      astal.notifd
    ];
  };
in
  stdenv.mkDerivation {
    pname = "astal";
    version = "1.0.0";
    src = ./.;

    buildInputs = [
      myAgs
      dart-sass
    ];

    installPhase = ''
      mkdir -p $out/share/wmain
      cp -r . $out/share/wmain

      mkdir -p $out/bin

      cat <<EOF > $out/bin/wmain
      #!${bash}/bin/bash
      export PATH=${lib.makeBinPath [dart-sass]}:\$PATH

      cd $out/share/wmain/conf/src
      if [ "\$#" -gt 0 ]; then
        ${myAgs}/bin/ags request "\$1" --instance bar
      else
        ${myAgs}/bin/ags run app.ts
      fi
      EOF

      cat <<EOF > $out/bin/wlauncher
      #!${bash}/bin/bash
      ${myAgs}/bin/ags request "launcher" --instance bar
      EOF

      cat <<EOF > $out/bin/wpowermenu
      #!${bash}/bin/bash
      ${myAgs}/bin/ags request "powermenu" --instance bar
      EOF

      chmod +x $out/bin/wmain
      chmod +x $out/bin/wlauncher
      chmod +x $out/bin/wpowermenu
    '';
  }
