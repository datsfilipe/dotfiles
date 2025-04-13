{
  self,
  nixpkgs,
  ...
} @ inputs: let
  inherit (inputs.nixpkgs) lib;
  myvars = import ../vars;
  mylib = import ../lib {
    inherit lib;
    inherit (builtins) builtins;
  };
  genMypkgs = system:
    import ../modules/nupkgs (inputs
      // {
        inherit lib mylib;
        pkgs = import inputs.nixpkgs {
          inherit system;
          config.allowUnfree = true;
          config.permittedInsecurePackages = [
            "openssl-1.1.1w"
          ];
        };
      });

  genSpecialArgs = system: let
    mypkgs = genMypkgs system;
  in
    inputs
    // {
      inherit mylib myvars mypkgs;

      pkgs-unstable = import inputs.nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
      pkgs-stable = import inputs.nixpkgs-stable {
        inherit system;
        config.allowUnfree = true;
      };
    };

  args = {inherit inputs lib mylib myvars genSpecialArgs;};

  nixosSystems = {
    x86_64-linux = import ./x86_64-linux (args // {system = "x86_64-linux";});
  };

  nixosSystemValues = builtins.attrValues nixosSystems;
  systemNames = builtins.attrNames nixosSystems;

  forAllSystems = func: (nixpkgs.lib.genAttrs systemNames func);

  mkScript = pkgs: name: text: let
    script =
      pkgs.writeShellScriptBin
      name
      text;
  in
    script;

  generateScritps = pkgs: [
    (mkScript pkgs "nixos_switch" ''
      local target=".#$1"
      local mode="$2"
      if [ "$mode" = "debug" ]; then
        nixos-rebuild switch --flake "$target" --show-trace --verbose
      elif [ "$mode" = "update" ]; then
        nix flake update
        nixos-rebuild switch --recreate-lock-file --flake "$target"
      else
        nix flake update datsnvim
        nix flake update unix-scripts
        nixos-rebuild switch --flake "$target"
      fi
    '')

    (mkScript pkgs "nixos_build" ''
      local target=".#$1"
      local mode="$2"
      if [ "$mode" = "debug" ]; then
        nixos-rebuild build --flake "$target" --show-trace --verbose
      elif [ "$mode" = "update" ]; then
        pushd "$DOTFILES_ROOT"
        ./scripts/update-nupkgs.sh ./modules/nupkgs
        nix flake update
        nixos-rebuild build --flake "$target"
        popd || exit 1
      else
        nixos-rebuild build --flake "$target"
      fi
    '')

    (mkScript pkgs "generate_flake" ''
      if [ -f flake.nix ]; then
        if ! command -v trash &> /dev/null; then
          rm flake.nix
        else
          trash flake.nix
        fi
      fi
      nix eval --raw -f templates/flake.template.nix flake > flake.nix
      alejandra flake.nix
    '')

    (mkScript pkgs "run_lib_tests" ''
      pushd "$DOTFILES_ROOT" || exit 1
      nix-shell -p nix-unit --run "nix-unit ./lib/spec.nix --gc-roots-dir ./.result-test"
      popd || exit 1
    '')
  ];
in {
  nixosConfigurations =
    lib.attrsets.mergeAttrsList (map (it: it.nixosConfigurations or {}) nixosSystemValues);

  packages = forAllSystems (
    system: nixosSystems.${system}.packages or {}
  );

  devShells = forAllSystems (
    system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      default = pkgs.mkShell {
        name = "dots";
        nativeBuildInputs = [] ++ (generateScritps pkgs);
        packages = with pkgs; [
          bashInteractive
          gcc
          alejandra
          just
        ];
        shellHook = ''
          export DOTFILES_ROOT=$(git rev-parse --show-toplevel)
        '';
      };
    }
  );

  formatter = forAllSystems (
    system: nixpkgs.legacyPackages.${system}.alejandra
  );
}
