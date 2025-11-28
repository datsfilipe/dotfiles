{
  config,
  mylib,
  pkgs,
  lib,
  ...
} @ args: let
  integrations = builtins.listToAttrs (
    map (path: {
      name = builtins.baseNameOf path;
      value = import path args;
    }) (mylib.file.scanPaths ./integrations ".nix")
  );

  moduleOptions = {
    options.modules.desktop.conf = lib.foldr (
      integration: acc:
        lib.recursiveUpdate acc
        (integration.configOptions.modules.desktop.conf or {})
    ) {} (builtins.attrValues integrations);
  };

  moduleConfig = {
    config = lib.mkMerge (
      map (integration: integration.configContent or {})
      (builtins.attrValues integrations)
    );
  };
in {
  imports = [];
  inherit (moduleOptions) options;
  inherit (moduleConfig) config;
}
