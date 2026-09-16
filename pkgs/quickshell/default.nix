{
  lib,
  stdenvNoCC,
  quickshell,
  makeWrapper,
  coreutils,
  gnugrep,
  gnused,
  gawk,
  procps,
  systemd,
  alacritty,
  iproute2,
  niri,
  brightnessctl,
  wireplumber,
  curl,
  usbutils,
  swaybg,
  imagemagick,
  findutils,
  xdg-utils,
  inetutils,
  lm_sensors,
  cava,
  wl-clipboard,
  reversal-icon-theme,
  inter,
  nerd-fonts,
  colorscheme,
  myvars,
  ...
}: let
  wallpaper = myvars.hostsConfig.wallpaper;
  wallpaperDir = builtins.dirOf wallpaper;
  terminal = myvars.hostsConfig.terminal;
  browser = myvars.hostsConfig.browser;
  dotfiles = myvars.dotfiles;
  runtimePath = lib.makeBinPath [
    coreutils
    gnugrep
    gnused
    gawk
    procps
    systemd
    alacritty
    iproute2
    niri
    brightnessctl
    wireplumber
    curl
    usbutils
    swaybg
    imagemagick
    findutils
    xdg-utils
    inetutils
    lm_sensors
    cava
    wl-clipboard
  ];

  fontDirs = lib.concatStringsSep ":" [
    "${inter}/share"
    "${nerd-fonts.jetbrains-mono}/share"
    "${reversal-icon-theme}/share"
  ];
in
  stdenvNoCC.mkDerivation {
    pname = "dats-quickshell";
    version = "2.0.0";
    src = ./conf;
    nativeBuildInputs = [makeWrapper];

    installPhase = ''
      mkdir -p $out/share/dats-quickshell $out/bin
      cp -r . $out/share/dats-quickshell
      substituteInPlace $out/share/dats-quickshell/config/Appearance.qml \
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
      substituteInPlace $out/share/dats-quickshell/config/Config.qml \
        --replace-fail @wallpaper@ ${lib.escapeShellArg wallpaper} \
        --replace-fail @wallpaperDir@ ${lib.escapeShellArg wallpaperDir} \
        --replace-fail @terminal@ ${lib.escapeShellArg terminal} \
        --replace-fail @browser@ ${lib.escapeShellArg browser}

      mkdir -p $out/libexec
      for script in wallpaper-preview wallpaper-restore wallpaper-apply wallpaper-thumbnails; do
        cp ${./scripts}/"$script" $out/libexec/"$script"
        chmod +w $out/libexec/"$script"
        substituteInPlace $out/libexec/"$script" \
          --replace-quiet @wallpaperDir@ ${lib.escapeShellArg wallpaperDir} \
          --replace-quiet @terminal@ ${lib.escapeShellArg terminal} \
          --replace-quiet @dotfiles@ ${lib.escapeShellArg dotfiles}
        chmod +x $out/libexec/"$script"
      done

      shellWrapper() {
        makeWrapper ${quickshell}/bin/qs $out/bin/"$1" \
          --prefix PATH : $out/bin:${runtimePath} \
          --prefix XDG_DATA_DIRS : ${fontDirs} \
          --set QS_ICON_THEME Reversal-dark \
          --add-flags "--path $out/share/dats-quickshell" \
          "''${@:2}"
      }

      makeWrapper ${quickshell}/bin/qs $out/bin/wgreet \
        --prefix PATH : ${runtimePath} \
        --prefix XDG_DATA_DIRS : ${fontDirs} \
        --add-flags "--path $out/share/dats-quickshell/greeter.qml"

      shellWrapper wmain
      shellWrapper wlauncher --add-flags "ipc call launcher toggle"
      shellWrapper wsession --add-flags "ipc call session toggle"
      shellWrapper wdashboard --add-flags "ipc call dashboard toggle"
      shellWrapper wcontrol --add-flags "ipc call control toggle"
      shellWrapper wnotifications --add-flags "ipc call notifications toggle"
      shellWrapper wmedia --add-flags "ipc call media toggle"
      shellWrapper wwallpapers --add-flags "ipc call wallpapers toggle"
      shellWrapper wlock --add-flags "ipc call lock lock"
      shellWrapper wvolume-osd --add-flags "ipc call osd volume"
      shellWrapper wbrightness-osd --add-flags "ipc call osd brightness"
      shellWrapper wbar --add-flags "ipc call shell"

      makeWrapper $out/libexec/wallpaper-preview $out/bin/wwallpaper-preview \
        --prefix PATH : ${runtimePath}
      makeWrapper $out/libexec/wallpaper-restore $out/bin/wwallpaper-restore \
        --prefix PATH : ${runtimePath}
      makeWrapper $out/libexec/wallpaper-apply $out/bin/wwallpaper-apply \
        --prefix PATH : ${runtimePath}
      makeWrapper $out/libexec/wallpaper-thumbnails $out/bin/wwallpaper-thumbnails \
        --prefix PATH : ${runtimePath}
    '';

    meta.mainProgram = "wmain";
  }
