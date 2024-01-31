{ pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    fishPlugins.hydro
    fishPlugins.done
    fishPlugins.z
  ];

  xdg.configFile."fish/conf.d/hydro.fish".text = ''
    set -l plugin_dir ${pkgs.fishPlugins.hydro}/share/fish

    ${lib.fileContents ../../../dotfiles/fish/conf.d/hydro.fish}
  '';

  xdg.configFile."fish/conf.d/done.fish".text = ''
    set -l plugin_dir ${pkgs.fishPlugins.done}/share/fish

    ${lib.fileContents ../../../dotfiles/fish/conf.d/done.fish}
  '';

  xdg.configFile."fish/conf.d/z.fish".text = ''
    set -l plugin_dir ${pkgs.fishPlugins.z}/share/fish

    ${lib.fileContents ../../../dotfiles/fish/conf.d/z.fish}
  '';
}
