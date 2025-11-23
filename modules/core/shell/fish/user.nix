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
        fish_user_key_bindings = ''
          bind --preset -M insert \cl 'clear; commandline -f repaint'
          bind --preset -M insert \a accept-autosuggestion
        '';
        dtc = ''
          devtunnel create $argv[1]
          devtunnel port create $argv[1] -p $argv[2]
          devtunnel access create $argv[1] -p $argv[2] --anonymous
          devtunnel host $argv[1]
        '';
      };

      shellInit = ''
        ${lib.fileContents ./conf/config.fish}
        export ${myvars.path}
        if command -v get-gh-token >/dev/null
          set -gx GH_TOKEN (get-gh-token)
        end
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
