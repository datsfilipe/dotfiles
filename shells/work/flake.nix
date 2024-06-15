{
  description = "dats nodejs shell";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    pre-commit-hooks.url = "github:cachix/git-hooks.nix";
  };

  outputs = { self, nixpkgs, flake-utils, pre-commit-hooks }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };

        inputs = with pkgs; [
          nodejs_20
          nodejs_20.pkgs.pnpm
          nodejs_20.pkgs.yarn
          libuuid
        ];
      in with pkgs; {
        checks = {
          pre-commit-check = pre-commit-hooks.lib.${system}.run {
            src = ./.;
            hooks = {
              lint = {
                enable = true;
                name = "lint";
                entry = "yarn lint --fix";
                files = "\\.(js|ts|jsx|tsx)$";
                stages = ["pre-push"];
              };
            };
          };
        };

        devShells.default = mkShell {
          inherit (self.checks.${system}.pre-commit-check) shellHook;
          buildInputs = self.checks.${system}.pre-commit-check.enabledPackages;
          name = "nodejs";
          packages = inputs;
          env = {
            LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [pkgs.libuuid];
          };
        };
      });
}
