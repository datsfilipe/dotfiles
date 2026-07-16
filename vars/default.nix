let
  username = "dtsf";
  localbin = "$HOME/.local/bin";
  gobin = "$HOME/go/bin";
  rustbin = "$HOME/.cargo/bin";
in {
  # general
  username = username;
  userfullname = "Filipe Lima";
  useremail = "datsfilipe.foss@proton.me";
  path = "PATH=\"$PATH:${localbin}:${gobin}:${rustbin}\"";
  sshAuthorizedKeys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINaF8YTdblaxjJATw1segJGHw69ooLnVY25Vz8hAo9kk datsfilipe.foss@proton.me"
  ];

  blockedHosts = [
    "instagram.com"
    "www.instagram.com"
    "x.com"
    "www.x.com"
    "twitter.com"
    "www.twitter.com"
  ];

  # build cache
  cache = {
    cachix = "datsfilipe-dotfiles";
    publicKeys = [
      "datsfilipe-dotfiles.cachix.org-1:lMJDrZFhAuqQrZXHPxJ/XceIptpJVnr3XNBVKDQHCOE="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    ];
  };

  # common hosts config
  hostsConfig = {
    theme = "gruvbox";
    wallpaper = "/home/dtsf/gdrive/walls/62.png";
    wallpaper-zoom = 0;

    # used by powermenu widget
    gif-filename = "gif0.gif";

    monitors = {
      pc = [
        {
          name = "DP-1";
          focus = true;
          resolution = "1920x1080";
          refreshRate = "179.998";
          nvidiaSettings = {
            coordinate = {
              x = 0;
              y = 420;
            };
            forceFullCompositionPipeline = true;
            rotation = "normal";
          };
        }
        {
          name = "DP-2";
          resolution = "1920x1080";
          refreshRate = "179.961";
          nvidiaSettings = {
            coordinate = {
              x = 1920;
              y = 0;
            };
            forceFullCompositionPipeline = true;
            rotation = "left";
          };
        }
      ];

      laptop = [
        {
          name = "eDP-1";
          resolution = "1920x1080";
          refreshRate = "59.997";
          scale = "1.5";
          nvidiaSettings = {
            coordinate = {
              x = 0;
              y = 0;
            };
            forceFullCompositionPipeline = true;
            rotation = "normal";
          };
        }
      ];
    };
  };
}
