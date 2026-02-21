{
  python3,
  fetchFromGitHub,
}: let
  source = builtins.fromJSON (builtins.readFile ./conf/source.json);
in
  python3.pkgs.buildPythonApplication {
    pname = "niri-stack-to-n";
    version = "unstable";
    pyproject = false;

    src = fetchFromGitHub {
      owner = "FarokhRaad";
      repo = "niri-stack-to-n";
      rev = source.rev;
      hash = source.hash;
    };

    dontBuild = true;

    installPhase = ''
      mkdir -p $out/bin
      cp niri_stack_to_n.py $out/bin/niri-stack-to-n
      chmod +x $out/bin/niri-stack-to-n
    '';

    meta = {
      description = "Automatically stack windows vertically on portrait displays in niri";
      homepage = "https://github.com/FarokhRaad/niri-stack-to-n";
      mainProgram = "niri-stack-to-n";
    };
  }
