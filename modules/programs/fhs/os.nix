{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.modules.programs.fhs.system;
in {
  options.modules.programs.fhs.system.enable = mkEnableOption "FHS environment and nix-ld support";

  config = mkIf cfg.enable {
    environment.systemPackages = [
      (
        let
          base = pkgs.appimageTools.defaultFhsEnvArgs;
        in
          pkgs.buildFHSEnv (base
            // {
              name = "fhs";
              targetPkgs = pkgs: (base.targetPkgs pkgs) ++ [pkgs.pkg-config];
              profile = "export FHS=1";
              runScript = "bash";
              extraOutputsToInstall = ["dev"];
            })
      )
    ];

    programs.nix-ld = {
      enable = true;
      libraries = with pkgs; [
        stdenv.cc.cc
      ];
    };
  };
}
