{
  lib,
  writeShellScriptBin,
  systemd,
  coreutils,
  ...
}:
writeShellScriptBin "focus-mode" (lib.replaceStrings
  ["@systemd@" "@coreutils@"]
  ["${systemd}" "${coreutils}"]
  (builtins.readFile ./conf/focus-mode.sh))
