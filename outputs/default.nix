{
  self,
  nixpkgs,
  ...
} @ inputs: let
  inherit (inputs.nixpkgs) lib;
  myvars = import ../vars;
  mylib = import ../lib {inherit lib; inherit (builtins) builtins;};
  genMypkgs = system: import ../modules/nupkgs (inputs // {
    inherit lib mylib;
    pkgs = import inputs.nixpkgs {
      inherit system;
      config.allowUnfree = true;
      config.permittedInsecurePackages = [
        "openssl-1.1.1w"
      ];
    };
  });

  genSpecialArgs = system:
    let
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
