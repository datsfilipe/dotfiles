{
  description = "dats git hooks shell";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        inputs = with pkgs; [
          lefthook
        ];
        hooks = [
          {
            name = "lint";
            run-on = "pre-commit";
            command = "npm run lint {staged_files}";
          }
          {
            name = "build";
            run-on = "pre-push";
            command = "npm run build";
          }
        ];
        transformHookToYaml = hook:
          let
            name = hook.name;
            runOn = hook.run-on;
            command = hook.command;
          in ''
            ${runOn}:
              commands:
                ${name}:
                  run: ${command}
          '';
        installHook = pkgs.writeShellScriptBin "install-hook" ''
          hookName=$1
          gitRoot=$(git rev-parse --show-toplevel)

          if [ -z "$hookName" ]; then
            echo "Please provide a hook name"
            exit 1
          fi

          hookFile=$(mktemp)
          echo "${transformHookToYaml { name = "$hookName"; run-on = "pre-commit"; command = "npm run lint"; }}" > $hookFile
          cp $hookFile $gitRoot/lefthook.yml
          lefthook install
        '';
      in with pkgs; {
        devShells.default = mkShell {
          name = "git-hooks";
          packages = inputs ++ [ installHook ];
        };
      });
}
