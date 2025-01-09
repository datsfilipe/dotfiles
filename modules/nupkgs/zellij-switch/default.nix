{ lib, fetchurl, runCommand }: let
  source = builtins.fromJSON (builtins.readFile ./conf/source.json);
  wasm = fetchurl {
    name = "zellij-switch.wasm";
    url = source.url;
    hash = "sha256-${source.sha256}";
  };
in runCommand "zellij-switch" {} ''
  mkdir -p $out/bin
  cp ${wasm} $out/bin/zellij-switch.wasm
''
