{
  self,
  nixpkgs,
  ...
} @ inputs: let
  inherit (inputs.nixpkgs) lib;
  mylib = import ../lib {inherit lib; inherit (builtins) builtins;};
  myvars = import ../vars {inherit lib;};

  genSpecialArgs = system:
    inputs
    // {
      inherit mylib myvars;

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
        packages = with pkgs; [
          bashInteractive
          gcc
          alejandra
          just
        ];
        name = "dots";
      };
    }
  );

  formatter = forAllSystems (
    system: nixpkgs.legacyPackages.${system}.alejandra
  );
}
