{
  config,
  pkgs,
  myvars,
  ...
} @ args: {
  nix.package = pkgs.nixVersions.latest;

  environment.variables.EDITOR = "nvim --clean";
  environment.systemPackages = with pkgs; [
    fastfetch
    neovim
    just
    fish
    git
    zip
    xz
    zstd
    p7zip
    gnugrep
    gawk
    jq
    dnsutils
    wget
    curl
    socat
    findutils
    which
    rsync
  ];

  users.users.${myvars.username} = {
    description = myvars.userfullname;
    openssh.authorizedKeys.keys = myvars.sshAuthorizedKeys;
  };

  nix.settings = {
    experimental-features = ["nix-command" "flakes"];
    trusted-users = [myvars.username];

    substituters = [
      "https://cache.nixos.org?priority=10"
      "https://nix-community.cachix.org"
    ];

    builders-use-substitutes = true;
  };
}
