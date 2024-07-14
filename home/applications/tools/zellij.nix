{ lib, theme, vars, ... }:

with lib; mkIf (vars.environment.multiplexer == "zellij") {
  programs.zellij = {
    enable = true;
    enableFishIntegration = true;
  };

  xdg.configFile."zellij/config.kdl".text = ''
    default_shell "${vars.environment.shell}"
    theme "custom"
    themes {
      custom {
        bg "${theme.scheme.colors.bg}"
        black "${theme.scheme.colors.bg}"
        blue "${theme.scheme.colors.blue}"
        cyan "${theme.scheme.colors.cyan}"
        fg "${theme.scheme.colors.fg}"
        green "${theme.scheme.colors.black}"
        magenta "${theme.scheme.colors.magenta}"
        orange "${theme.scheme.colors.green}"
        red "${theme.scheme.colors.red}"
        white "${theme.scheme.colors.white}"
        yellow "${theme.scheme.colors.yellow}"
      }
    }

    ${fileContents ../../../dotfiles/zellij/config.kdl}
  '';

  xdg.configFile."zellij/layouts/default.kdl".source = ../../../dotfiles/zellij/layouts/default.kdl;
}
