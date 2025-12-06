let
  username = "dtsf";
  homedir = "/home/${username}";
  localbin = "${homedir}/.local/bin";
  gobin = "${homedir}/go/bin";
  rustbin = "${homedir}/.cargo/bin";
in {
  # general
  username = username;
  userfullname = "Filipe Lima";
  useremail = "datsfilipe.foss@proton.me";
  path = "PATH=\"$PATH:${localbin}:${gobin}:${rustbin}\"";
  sshAuthorizedKeys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINaF8YTdblaxjJATw1segJGHw69ooLnVY25Vz8hAo9kk datsfilipe.foss@proton.me"
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
    theme = "vesper";
    wallpaper = "/home/dtsf/gdrive/walls/46.png";

    # used by powermenu widget
    gif-filename = "gif0.gif";

    monitors = {
      pc = [
        {
          name = "DP-2";
          focus = true;
          resolution = "1920x1080";
          refreshRate = "180";
          nvidiaSettings = {
            coordinate = {
              x = 0;
              y = 15;
            };
            forceFullCompositionPipeline = true;
            rotation = "normal";
          };
        }
        {
          name = "HDMI-A-1";
          resolution = "1920x1080";
          refreshRate = "75";
          scale = "1.1";
          nvidiaSettings = {
            coordinate = {
              x = 1920;
              y = 0;
            };
            forceFullCompositionPipeline = true;
            rotation = "normal";
          };
        }
      ];

      laptop = [
        {
          name = "eDP-1";
          resolution = "1920x1080";
          refreshRate = "59.997";
          scale = "1.3";
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
