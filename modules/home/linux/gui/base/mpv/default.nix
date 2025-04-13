{pkgs, ...}: {
  programs = {
    mpv = {
      enable = true;
      defaultProfiles = ["gpu-hq"];
      scripts = map (path:
        pkgs.stdenv.mkDerivation {
          pname = "mpv-${builtins.baseNameOf path}";
          version = "1.0";
          src = ./conf;
          installPhase = ''
            mkdir -p $out/share/mpv/scripts
            cp ${builtins.baseNameOf path} $out/share/mpv/scripts/
          '';
          passthru.scriptName = builtins.baseNameOf path;
        }) [./conf/autosave.lua ./conf/notify-send.lua];
    };
  };
}
