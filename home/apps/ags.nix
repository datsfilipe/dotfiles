{ inputs, pkgs, ... }:

let
  theme = (import ../../modules/colorscheme).theme;
in {
  imports = [ inputs.ags.homeManagerModules.default ];

  home.packages = with pkgs; [
    (python311.withPackages (p: [ p.python-pam ]))
  ];

  programs.ags = {
    enable = true;
    extraPackages = [ pkgs.libsoup_3 ];
  };

  xdg.configFile."ags" = {
    source = ../../dotfiles/ags;
    recursive = true;
  };

  xdg.configFile."ags/style.css".text = ''
    /* unset styles */
    box, centerbox, window{
      all: unset;
    }

    /* general */
    label {
      font-weight: bold;
    }

    progress, highlight {
      background: ${theme.scheme.colors.red};
      min-height: 4px;
      border-radius: 4px;
    }

    slider {
      box-shadow: none;
      background-color: transparent;
      border: 1px solid transparent;
      border-radius: 1em;
      min-height: 0.7em;
      min-width: 0.7em;
    }

    /* bar */
    .bar {
      color: ${theme.scheme.colors.fg};
      background: ${theme.scheme.colors.bg};
      font-size: 10px;
    }

    .tray {
      margin: 0 6px;
    }

    .tray button {
      background: transparent;
      border: none;
    }

    .workspaces button {
      background: transparent;
      margin: 2px;
      border-radius: 0;
      padding: 0 0.4rem;
    }

    .workspaces button.focused {
      background: ${theme.scheme.colors.blue};
      color: ${theme.scheme.colors.bg};
    }

    .workspaces button.occupied {
      background: ${theme.scheme.colors.altbg};
    }

    .client-title {
      margin-left: 1em;
      color: ${theme.scheme.colors.red};
    }

    .clock {
      margin: 0 6px;
    }

    .popup-bg {
      min-width: 5000px;
      min-height: 3000px;
    }

    .black {
      background-color: rgba(0, 0, 0, 0.8);
    }

    .powermenu button {
      background: ${theme.scheme.colors.bg};
      border-radius: 0;
      border: 1px solid ${theme.scheme.colors.altbg};
      margin: 0 8px;
      min-height: 40px;
      font-weight: bold;
    }

    .sleep {
      color: ${theme.scheme.colors.green};
    }

    .reboot {
      color: ${theme.scheme.colors.blue};
    }

    .shutdown {
      color: ${theme.scheme.colors.red};
    }

    .logout {
      color: ${theme.scheme.colors.yellow};
    }

    .verification {
      min-height: 80px;
    }

    .verification .description {
      font-weight: bold;
      color: ${theme.scheme.colors.fg};
    }

    .verification .buttons button {
      background: ${theme.scheme.colors.bg};
      border: 1px solid ${theme.scheme.colors.altbg};
      margin: 10px 8px;
      border-radius: 0;
    }

    .volume, .microphone {
      min-width: 14em;
      min-width: 14em;
    }

    .volume button, .microphone button {
      border: 1px solid transparent;
      outline: none;
      background: transparent;
    }

    /* launcher */
    .launcher {
      background-color: ${theme.scheme.colors.bg};
      border-radius: 0;
      padding: 1rem;
      margin: 2rem;
      min-width: 25rem;
      min-height: 45rem;
    }

    .launcher .search-entry {
      padding: 0.2rem 0.8rem;
      margin-bottom: 12px;
      border-radius: 0px;
      font-size: 1.1rem;
      font-family: JetBrainsMono Nerd Font;
    }

    .launcher scrollbar, .launcher scrollbar * {
      all: unset;
    }

    .launcher .app-button {
      padding: 4px;
      border-radius: 0px;
      margin-bottom: 10px;
    }

    .launcher .app-icon {
      font-size: 3rem;
      margin-right: 5px;
    }
    
    .launcher .app-name {
      font-weight: bold;
      font-size: 1rem;
    }

    .launcher .app-description {
      font-size: 0.8rem;
    }

    .launcher .app-description.focused {
      background-color: ${theme.scheme.colors.altbg};
    }
  '';
}
