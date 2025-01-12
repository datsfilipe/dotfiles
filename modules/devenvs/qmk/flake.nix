{
  description = "Flake para construir firmware vial-qmk";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
  inputs.nixos-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

  inputs.vial-qmk = {
    url = "git+https://github.com/vial-kb/vial-qmk.git?submodules=1&ref=vial";
    flake = false;
  };

  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = {
    self,
    nixpkgs,
    nixos-unstable,
    vial-qmk,
    flake-utils,
  }:
    flake-utils.lib.eachSystem ["x86_64-linux"] (
      system: let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            (final: prev: {
              unstable = nixos-unstable.legacyPackages."${prev.system}";
            })

            (final: prev: {
              python3 = final.python310;
              python3Packages = final.python310.pkgs;
            })
          ];
        };

        VIAL_QMK_DIR = "${vial-qmk}";
        KEYBOARD = "lily58";
        KEYMAP = "vial";
        CONTROLLER = "promicro_rp2040";

        build = pkgs.writeShellScriptBin "build" ''
          make -C ${VIAL_QMK_DIR} BUILD_DIR=`pwd`/build COPY=echo -j8 ${KEYBOARD}:${KEYMAP} CONVERT_TO=${CONTROLLER}
        '';
        flash = pkgs.writeShellScriptBin "flash" ''
          make -C ${VIAL_QMK_DIR} BUILD_DIR=`pwd`/build COPY=echo -j8 ${KEYBOARD}:${KEYMAP}:flash CONVERT_TO=${CONTROLLER}
        '';
      in {
        devShell = pkgs.mkShell {
          name = "qmk-shell";
          env = {
            VIAL_QMK_DIR = VIAL_QMK_DIR;
            KEYBOARD = KEYBOARD;
            KEYMAP = KEYMAP;
            CONTROLLER = CONTROLLER;
          };
          packages = [build flash pkgs.qmk pkgs.unstable.vial];
        };
      }
    );
}
