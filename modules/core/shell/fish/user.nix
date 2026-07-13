{
  lib,
  config,
  pkgs-unstable,
  myvars,
  ...
}:
with lib; let
  cfg = config.modules.core.shell.fish.user;
  shellAliases = import ./shellAliases.nix;
  pkgs = pkgs-unstable;
  plugins = [
    {
      name = "hydro";
      pkg = pkgs.fishPlugins.hydro;
    }
    {
      name = "done";
      pkg = pkgs.fishPlugins.done;
    }
  ];
in {
  options.modules.core.shell.fish.user.enable = mkEnableOption "Fish shell configuration for the user";

  config = mkIf cfg.enable {
    home.shellAliases = shellAliases;
    home.packages = with pkgs;
      (map (p: p.pkg) plugins) ++ [pkgs.zoxide];

    programs.fish = {
      enable = true;
      functions = {
        fish_user_key_bindings = lib.fileContents ./conf/keybindings.fish;
        dtc = lib.fileContents ./conf/dtc.fish;
      };

      shellInit = ''
        ${lib.fileContents ./conf/config.fish}
        export ${myvars.path}
        ${lib.fileContents ./conf/init.fish}
      '';
    };

    xdg.configFile =
      lib.foldl' (
        acc: plugin:
          acc
          // {
            "fish/conf.d/${plugin.name}.fish".text = ''
              set -l plugin_dir ${plugin.pkg}/share/fish
              ${lib.fileContents ./conf/plugin.fish}
            '';
          }
      ) {}
      plugins;
  };
}
