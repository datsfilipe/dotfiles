{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  wayland,
  wayland-protocols,
  wayland-scanner,
  libarchive,
  uthash,
  python3,
  makeWrapper,
  which,
  gnused,
  procps,
  coreutils,
}: let
  # Read version info from source.json
  source = builtins.fromJSON (builtins.readFile ./conf/source.json);
  mascotsDir = ./conf/shimeji-ee;
  pythonEnv = python3.withPackages (ps: [ps.pillow]);
in
  stdenv.mkDerivation rec {
    pname = "wl-shimeji";
    version = "0.0.1-${builtins.substring 0 7 source.rev}"; # Use short hash in version

    src = fetchFromGitHub {
      owner = "CluelessCatBurger";
      repo = "wl_shimeji";
      rev = source.rev;
      hash = source.hash;
      fetchSubmodules = true;
    };

    nativeBuildInputs = [
      pkg-config
      wayland-scanner
      makeWrapper
      pythonEnv
      which
      gnused
    ];

    buildInputs = [
      wayland
      wayland-protocols
      libarchive
      uthash
    ];

    enableParallelBuilding = true;

    postPatch = ''
      chmod +x scripts/py-compose.py
      patchShebangs scripts/py-compose.py
    '';

    installPhase = ''
      runHook preInstall

      make install PREFIX=$out

      patchShebangs $out/bin

      wrapProgram $out/bin/shimejictl \
        --prefix PYTHONPATH : "${pythonEnv}/${pythonEnv.sitePackages}" \
        --prefix PATH : "$out/bin:${pythonEnv}/bin"

      # Copy zips
      mkdir -p $out/share/wl-shimeji/zips
      cp "${mascotsDir}"/*.zip $out/share/wl-shimeji/zips/

      # Create runtime wrappers
      for zipfile in $out/share/wl-shimeji/zips/*.zip; do
        zip_basename=$(basename "$zipfile")
        name_no_ext="''${zip_basename%.*}"
        bin_name="wl-shimeji-$(echo "$name_no_ext" | tr '[:upper:]' '[:lower:]')"

        echo "Creating runtime launcher: $bin_name"

        cat > $out/bin/$bin_name <<EOF
      #!/bin/sh
      set -e

      # 1. Daemon Keep-Alive
      if ! ${procps}/bin/pgrep -f "shimeji-overlayd" > /dev/null; then
        echo "Starting shimeji-overlayd..."
        ${coreutils}/bin/nohup $out/bin/shimeji-overlayd > /dev/null 2>&1 &
        sleep 1
      fi

      CACHE_DIR="\$HOME/.cache/wl-shimeji/converted/$name_no_ext"
      mkdir -p "\$CACHE_DIR"

      # 2. Convert
      echo "Attempting conversion of $name_no_ext..."
      echo "A" | $out/bin/shimejictl convert "$zipfile" -O "\$CACHE_DIR" > /dev/null 2>&1 || true

      # 3. Check for success
      count=\$(find "\$CACHE_DIR" -maxdepth 1 -name "Shimeji.*.wlshm" | wc -l)
      if [ "\$count" -eq 0 ]; then
          echo "Error: Conversion failed. No prototype files found."
          echo "The zip file '$name_no_ext.zip' likely uses an unsupported directory structure."
          exit 1
      fi

      # 4. Smart Selection Logic
      BEST_MATCH=""
      FIRST_FOUND=""
      ZIP_LOWER=\$(echo "$name_no_ext" | tr '[:upper:]' '[:lower:]')

      for wlshm in "\$CACHE_DIR"/Shimeji.*.wlshm; do
          [ -e "\$wlshm" ] || continue

          # Import
          $out/bin/shimejictl prototypes import "\$wlshm" > /dev/null 2>&1 || true

          # Extract internal name
          base=\$(basename "\$wlshm")
          internal_name=\$(echo "\$base" | ${gnused}/bin/sed -E 's/^Shimeji\.(.+)\.wlshm\$/\1/')
          NAME_LOWER=\$(echo "\$internal_name" | tr '[:upper:]' '[:lower:]')

          if [ -z "\$FIRST_FOUND" ]; then
              FIRST_FOUND="\$internal_name"
          fi

          # Fuzzy match zip name to mascot name
          if echo "\$ZIP_LOWER" | grep -q "\$NAME_LOWER"; then
              BEST_MATCH="\$internal_name"
          fi
      done

      # 5. Summon
      if [ -n "\$BEST_MATCH" ]; then
          echo "Summoning \$BEST_MATCH..."
          $out/bin/shimejictl mascot summon "\$BEST_MATCH"
      elif [ -n "\$FIRST_FOUND" ]; then
          echo "Summoning \$FIRST_FOUND..."
          $out/bin/shimejictl mascot summon "\$FIRST_FOUND"
      else
          echo "Error: Valid prototypes exist but could not be parsed."
          exit 1
      fi
      EOF

        chmod +x "$out/bin/$bin_name"
      done

      runHook postInstall
    '';

    meta = with lib; {
      description = "Shimeji for Wayland (Custom Collection)";
      homepage = "https://github.com/CluelessCatBurger/wl_shimeji";
      license = licenses.gpl3Only; # Updated to GPLv3 based on repo
      platforms = platforms.linux;
    };
  }
