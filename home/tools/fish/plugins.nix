{ pkgs, ... }:

{
  home.packages = with pkgs; [
    fishPlugins.hydro
    fishPlugins.done
    fishPlugins.z
  ];

  xdg.configFile."fish/conf.d/hydro.fish".text = ''
    set -l plugin_dir ${pkgs.fishPlugins.hydro}/share/fish
    if test -d $plugin_dir/vendor_functions.d
      set fish_function_path $fish_function_path[1] $plugin_dir/vendor_functions.d $fish_function_path[2..-1]
    end
    if test -d $plugin_dir/vendor_completions.d
      set fish_complete_path $fish_complete_path[1] $plugin_dir/vendor_completions.d $fish_complete_path[2..-1]
    end
    if test -d $plugin_dir/vendor_conf.d
      for f in $plugin_dir/vendor_conf.d/*.fish
        source $f
      end
    end
    if test -f $plugin_dir/key_bindings.fish
      source $plugin_dir/key_bindings.fish
    end
    if test -f $plugin_dir/init.fish
      source $plugin_dir/init.fish
    end
  '';

  xdg.configFile."fish/conf.d/done.fish".text = ''
    set -l plugin_dir ${pkgs.fishPlugins.done}/share/fish
    if test -d $plugin_dir/vendor_functions.d
      set fish_function_path $fish_function_path[1] $plugin_dir/vendor_functions.d $fish_function_path[2..-1]
    end
    if test -d $plugin_dir/vendor_completions.d
      set fish_complete_path $fish_complete_path[1] $plugin_dir/vendor_completions.d $fish_complete_path[2..-1]
    end
    if test -d $plugin_dir/vendor_conf.d
      for f in $plugin_dir/vendor_conf.d/*.fish
        source $f
      end
    end
    if test -f $plugin_dir/key_bindings.fish
      source $plugin_dir/key_bindings.fish
    end
    if test -f $plugin_dir/init.fish
      source $plugin_dir/init.fish
    end
  '';

  xdg.configFile."fish/conf.d/z.fish".text = ''
    set -l plugin_dir ${pkgs.fishPlugins.z}/share/fish
    if test -d $plugin_dir/vendor_functions.d
      set fish_function_path $fish_function_path[1] $plugin_dir/vendor_functions.d $fish_function_path[2..-1]
    end
    if test -d $plugin_dir/vendor_completions.d
      set fish_complete_path $fish_complete_path[1] $plugin_dir/vendor_completions.d $fish_complete_path[2..-1]
    end
    if test -d $plugin_dir/vendor_conf.d
      for f in $plugin_dir/vendor_conf.d/*.fish
        source $f
      end
    end
    if test -f $plugin_dir/key_bindings.fish
      source $plugin_dir/key_bindings.fish
    end
    if test -f $plugin_dir/init.fish
      source $plugin_dir/init.fish
    end
  '';
}
