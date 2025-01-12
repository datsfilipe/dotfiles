{
  description = "dats git hooks shell";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {inherit system;};
      inputs = with pkgs; [
        lefthook
      ];
      hooksModule = import ./hooks.nix;
      hooks = hooksModule.hooks;
      transformHookToYaml = hook: let
        name = hook.name;
        runOn = hook.run-on;
        command = hook.command;
      in
        if hook == {}
        then ""
        else ''
          ${runOn}:
          commands:
          ${name}:
          run: ${command}
        '';
      getHook = name: let
        filteredHooks = builtins.filter (hook: hook.name == name) hooks;
      in
        if builtins.length filteredHooks > 0
        then builtins.elemAt filteredHooks 0
        else {};
      installHook = pkgs.writeShellScriptBin "install-hook" ''
                  if [ "$#" -lt 1 ]; then
                    echo "Please provide at least one hook name"
                      exit 1
                      fi

                      gitRoot=$(git rev-parse --show-toplevel)
                      hookFile=$(mktemp)

                      for hookName in "$@"; do
        case "$hookName" in
                        "eslint")
                          echo "${transformHookToYaml (getHook "eslint")}"
                          ;;
                        "lint")
                          echo "${transformHookToYaml (getHook "lint")}"
                          ;;
                        "prettier")
                          echo "${transformHookToYaml (getHook "prettier")}"
                          ;;
                        "normalize-filenames")
                          echo "${transformHookToYaml (getHook "normalize-filenames")}"
                          ;;
                        "normalize-filenames-on-push")
                          echo "${transformHookToYaml (getHook "normalize-filenames-on-push")}"
                          ;;
                        *)
                          echo "Hook $hookName not found"
                          exit 1
                          ;;
                        esac
                          done > $hookFile

                          cp $hookFile $gitRoot/lefthook.yml
                          lefthook install
      '';
    in
      with pkgs; {
        devShells.default = mkShell {
          name = "git-hooks";
          packages = inputs ++ [installHook];
        };
      });
}
