{
  config,
  lib,
  mylib,
  pkgs,
  myvars,
  ...
}: let
  homeDir = "/Users/${myvars.username}";

  blockedHostsBegin = "# BEGIN nix-darwin blocked-hosts";
  blockedHostsEnd = "# END nix-darwin blocked-hosts";
  blockedHostsBlock =
    blockedHostsBegin
    + "\n"
    + lib.concatMapStrings (h: "127.0.0.1 ${h}\n::1 ${h}\n") myvars.blockedHosts
    + blockedHostsEnd;
in {
  nixpkgs.config.allowUnfree = true;
  system.primaryUser = myvars.username;

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
    (pkgs.writeShellScriptBin "get-gh-token" (mylib.file.substitute ./conf/get-gh-token.sh {
      "@orgTokenPath@" = config.sops.secrets."token/github/dtsf-pc-org".path;
      "@tokenPath@" = config.sops.secrets."token/github/dtsf-pc".path;
    }))
    (pkgs.writeShellScriptBin "get-claude-config-dir" (builtins.readFile ./conf/get-claude-config-dir.sh))
  ];

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "none";
    };
    casks = [
      "tableplus"
      "zoom"
      "slack"
      "bitwarden"
      "google-drive"
    ];
  };

  security.pam.services.sudo_local.touchIdAuth = true;

  system.activationScripts.postActivation.text = ''
    dscl . -create /Users/${myvars.username} UserShell /run/current-system/sw/bin/fish

    block=${lib.escapeShellArg blockedHostsBlock}
    tmp=$(mktemp)
    ${pkgs.gawk}/bin/awk -v b=${lib.escapeShellArg blockedHostsBegin} -v e=${lib.escapeShellArg blockedHostsEnd} '
      $0==b {skip=1}
      skip==0 {print}
      $0==e {skip=0}
    ' /etc/hosts > "$tmp"
    printf '%s\n' "$block" >> "$tmp"
    cat "$tmp" > /etc/hosts
    rm -f "$tmp"
  '';

  services.skhd = {
    enable = true;
    skhdConfig = let
      bin = "/etc/profiles/per-user/${myvars.username}/bin";
      openZellij = pkgs.writeShellScript "skhd-open-zellij" (mylib.file.substitute ./conf/open-zellij.sh {
        "@bin@" = bin;
      });
    in ''
      cmd - return : ${openZellij}
      shift + cmd - return : ${bin}/alacritty
    '';
  };

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
        autohide = false;
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
