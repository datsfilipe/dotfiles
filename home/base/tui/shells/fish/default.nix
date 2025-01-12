{
  pkgs,
  lib,
  path,
  ...
}:
with lib; let
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
  programs.fish = {
    enable = true;
    functions = {
      dtc = ''
        devtunnel create $argv[1]
        devtunnel port create $argv[1] -p $argv[2]
        devtunnel access create $argv[1] -p $argv[2] --anonymous
        devtunnel host $argv[1]
      '';
    };

    shellInit = ''
        ${fileContents ./conf/config.fish}
      export ${path}
    '';
  };

  home.packages = with pkgs;
    (map (p: p.pkg) plugins) ++ [zoxide];

  xdg.configFile = lib.foldl' (
    acc: plugin:
      acc
      // {
        "fish/conf.d/${plugin.name}.fish".text = ''
          set -l plugin_dir ${plugin.pkg}/share/fish
          ${fileContents ./conf/plugin.fish}
        '';
      }
  ) {}
  plugins;
}
