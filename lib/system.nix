{
  lib,
  system,
  specialArgs,
  systemModules,
  systemConstructor,
  homeManagerModule,
  home-modules,
  myvars,
}:
systemConstructor {
  inherit system specialArgs;
  modules =
    systemModules
    ++ lib.optionals (home-modules != []) [
      homeManagerModule
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.backupFileExtension = "hm.backup";
        home-manager.extraSpecialArgs = specialArgs;
        home-manager.users."${myvars.username}".imports = home-modules;
      }
    ];
}
