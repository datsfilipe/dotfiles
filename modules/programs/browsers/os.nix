{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.programs.browsers.system;
in {
  options.modules.programs.browsers.system.enable = mkEnableOption "Browser managed policies";

  config = mkIf cfg.enable {
    environment.etc."brave/policies/managed/policy.json".source = ./conf/policy.json;
    environment.etc."chromium/policies/managed/policy.json".source = ./conf/chromium-policy.json;
  };
}
