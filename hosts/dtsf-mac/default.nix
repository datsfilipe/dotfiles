{
  config,
  lib,
  pkgs,
  myvars,
  ...
}: let
  homeDir = "/Users/${myvars.username}";
in {
  nixpkgs.config.allowUnfree = true;

  sops = {
    age.generateKey = false;
    age.sshKeyPaths = ["${homeDir}/.ssh/alt_key"];
    age.keyFile = "${homeDir}/.config/sops/age/keys.txt";
    defaultSopsFile = ../../modules/secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    secrets."token/github/dtsf-pc" = {
      owner = myvars.username;
    };
    secrets."token/github/dtsf-pc-org" = {
      owner = myvars.username;
    };
  };

  nix = {
    package = pkgs.nixVersions.latest;
    gc = {
      automatic = true;
      interval = {
        Weekday = 0;
        Hour = 2;
        Minute = 0;
      };
      options = "--delete-older-than 7d";
    };
    settings = {
      auto-optimise-store = true;
      experimental-features = ["nix-command" "flakes"];
      trusted-users = [myvars.username];
      substituters = [
        "https://cache.nixos.org?priority=10"
        "https://${myvars.cache.cachix}.cachix.org"
      ];
      builders-use-substitutes = true;
      trusted-public-keys = myvars.cache.publicKeys;
    };
  };

  users.users.${myvars.username} = {
    home = "/Users/${myvars.username}";
    shell = pkgs.fish;
  };

  programs.fish.enable = true;
  environment.shells = [pkgs.fish pkgs.bashInteractive];

  fonts.packages = with pkgs; [
    inter
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    nerd-fonts.jetbrains-mono
  ];

  environment.systemPackages = with pkgs; [
    fastfetch
    just
    fish
    git
    eza
    zip
    fzf
    ripgrep
    unzip
    xz
    zstd
    p7zip
    gnugrep
    gawk
    jq
    wget
    curl
    socat
    findutils
    which
    rsync
    gcc
    gnumake
    gum
    (pkgs.writeScriptBin "get-gh-token" ''
      #!${pkgs.bash}/bin/bash
      case "$PWD" in
        /Users/*/org|/Users/*/org/*)
          cat ${config.sops.secrets."token/github/dtsf-pc-org".path}
          ;;
        *)
          cat ${config.sops.secrets."token/github/dtsf-pc".path}
          ;;
      esac
    '')
    (pkgs.writeScriptBin "get-claude-config-dir" ''
      #!${pkgs.bash}/bin/bash
      case "$PWD" in
        /Users/*/org|/Users/*/org/*)
          echo "$HOME/.claude-org"
          ;;
        *)
          echo "$HOME/.claude"
          ;;
      esac
    '')
  ];

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
    };
    casks = [
      "tableplus"
      "zoom"
      "slack"
      "bitwarden"
      "obs"
      "qbittorrent"
    ];
  };

  security.pam.services.sudo_local.touchIdAuth = true;

  system = {
    defaults = {
      NSGlobalDomain = {
        AppleShowAllExtensions = true;
        AppleInterfaceStyle = "Dark";
        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticSpellingCorrectionEnabled = false;
        "com.apple.swipescrolldirection" = false;
      };
      dock = {
        autohide = true;
        show-recents = false;
        mru-spaces = false;
      };
      finder = {
        AppleShowAllExtensions = true;
        ShowPathbar = true;
        ShowStatusBar = true;
      };
      trackpad = {
        Clicking = true;
        TrackpadThreeFingerDrag = true;
      };
    };
    stateVersion = 6;
  };
}
