{
  lib,
  stdenvNoCC,
  quickshell,
  makeWrapper,
  coreutils,
  gnugrep,
  iproute2,
  niri,
  brightnessctl,
  colorscheme,
  ...
}: let
  runtimePath = lib.makeBinPath [coreutils gnugrep iproute2 niri brightnessctl];
in
  stdenvNoCC.mkDerivation {
    pname = "dats-quickshell";
    version = "1.0.0";
    src = ./conf;
    nativeBuildInputs = [makeWrapper];

    installPhase = ''
      mkdir -p $out/share/dats-quickshell $out/bin
      cp -r . $out/share/dats-quickshell
      substituteInPlace $out/share/dats-quickshell/Theme.qml \
        --replace-fail @primary@ ${lib.escapeShellArg colorscheme.colors.primary} \
        --replace-fail @background@ ${lib.escapeShellArg colorscheme.colors.bg} \
        --replace-fail @alternate@ ${lib.escapeShellArg colorscheme.colors.altbg} \
        --replace-fail @selection@ ${lib.escapeShellArg colorscheme.colors.selection} \
        --replace-fail @foreground@ ${lib.escapeShellArg colorscheme.colors.fg} \
        --replace-fail @black@ ${lib.escapeShellArg colorscheme.colors.black} \
        --replace-fail @red@ ${lib.escapeShellArg colorscheme.colors.red} \
        --replace-fail @green@ ${lib.escapeShellArg colorscheme.colors.green} \
        --replace-fail @yellow@ ${lib.escapeShellArg colorscheme.colors.yellow} \
        --replace-fail @blue@ ${lib.escapeShellArg colorscheme.colors.blue} \
        --replace-fail @magenta@ ${lib.escapeShellArg colorscheme.colors.magenta} \
        --replace-fail @cyan@ ${lib.escapeShellArg colorscheme.colors.cyan} \
        --replace-fail @white@ ${lib.escapeShellArg colorscheme.colors.white}
      makeWrapper ${quickshell}/bin/qs $out/bin/wmain \
        --prefix PATH : ${runtimePath} \
        --add-flags "--path $out/share/dats-quickshell"
      makeWrapper ${quickshell}/bin/qs $out/bin/wlauncher \
        --prefix PATH : ${runtimePath} \
        --add-flags "--path $out/share/dats-quickshell ipc call launcher toggle"
      makeWrapper ${quickshell}/bin/qs $out/bin/wpowermenu \
        --prefix PATH : ${runtimePath} \
        --add-flags "--path $out/share/dats-quickshell ipc call powermenu toggle"
      makeWrapper ${quickshell}/bin/qs $out/bin/wbrightness-osd \
        --prefix PATH : ${runtimePath} \
        --add-flags "--path $out/share/dats-quickshell ipc call osd brightness"
      makeWrapper ${quickshell}/bin/qs $out/bin/wbar-autohide \
        --prefix PATH : ${runtimePath} \
        --add-flags "--path $out/share/dats-quickshell ipc call shell"
    '';

    meta.mainProgram = "wmain";
  }
