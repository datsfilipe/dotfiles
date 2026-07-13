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
    import ../pkgs (inputs
      // {
        inherit lib mylib;
        theme = myvars.hostsConfig.theme;
        unix-scripts = inputs.unix-scripts;
        gif-filename = myvars.hostsConfig.gif-filename;
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

  darwinSystems = {
    aarch64-darwin = import ./aarch64-darwin (args // {system = "aarch64-darwin";});
  };

  nixosSystemValues = builtins.attrValues nixosSystems;
  darwinSystemValues = builtins.attrValues darwinSystems;
  allSystemNames = builtins.attrNames nixosSystems ++ builtins.attrNames darwinSystems;

  forAllSystems = func: (nixpkgs.lib.genAttrs allSystemNames func);

  mkScript = pkgs: name: text: let
    script =
      pkgs.writeShellScriptBin
      name
      text;
  in
    script;

  generateScritps = pkgs:
    map
    (name: mkScript pkgs name (builtins.readFile ./conf/${name}.sh))
    [
      "nixos_switch"
      "nixos_build"
      "generate_flake"
      "run_lib_tests"
      "darwin_switch"
      "j"
    ];
in {
  nixosConfigurations =
    lib.attrsets.mergeAttrsList (map (it: it.nixosConfigurations or {}) nixosSystemValues);

  darwinConfigurations =
    lib.attrsets.mergeAttrsList (map (it: it.darwinConfigurations or {}) darwinSystemValues);

  packages = forAllSystems (
    system:
      (nixosSystems.${system}.packages or {})
      // (darwinSystems.${system}.packages or {})
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
          kdlfmt
          shfmt
          fish
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
