{
  config,
  pkgs,
  lib,
  myvars,
  mypkgs,
  ...
}: let
  jellyfinJellyNext = pkgs.fetchzip {
    url = "https://github.com/luall0/jellynext/releases/download/v1.3.0.0/jellynext-v1.3.0.0.zip";
    hash = "sha256-RnfvN+Kb1kJNcJVT/B0xUPSlz+NXyqTRO9TAkvvoC2s=";
    stripRoot = false;
  };
  jellyfinTrakt = pkgs.fetchzip {
    url = "https://github.com/jellyfin/jellyfin-plugin-trakt/releases/download/v30/trakt_30.0.0.0.zip";
    hash = "sha256-CLdvWaGYTEZxLzm8ZPVHKhemp0EgCeJ/QvBMZPI2nYk=";
    stripRoot = false;
  };
in {
  services.filebrowser = {
    enable = true;
    user = myvars.username;
    group = "users";
    openFirewall = false;
    settings = {
      port = 8080;
      root = "/home/${myvars.username}";
      address = "127.0.0.1";
      baseURL = "/files";
    };
  };
  services.jellyfin = {
    enable = true;
    openFirewall = false;
    user = myvars.username;
  };
  systemd.tmpfiles.rules = [
    "d /var/lib/jellyfin/plugins 0755 ${myvars.username} users -"
    "d /var/lib/jellyfin/plugins/JellyNext_v1.3.0.0 0755 ${myvars.username} users -"
    "d /var/lib/jellyfin/plugins/Trakt_30.0.0.0 0755 ${myvars.username} users -"
    "d /home/dtsf-2 0700 dtsf-2 users -"
    "d /home/${myvars.username}/downloads 0755 ${myvars.username} users -"
  ];
  environment.etc."jellyfin-network.xml".text = ''
    <?xml version="1.0" encoding="utf-8"?>
    <NetworkConfiguration xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
      <BaseUrl>/jellyfin</BaseUrl>
    </NetworkConfiguration>
  '';
  systemd.services.jellyfin.preStart = ''
    rm -rf /var/lib/jellyfin/plugins/StarTrack
    rm -rf /var/lib/jellyfin/plugins/MindTheGaps

    jellyNextDir=/var/lib/jellyfin/plugins/JellyNext_v1.3.0.0
    install -d -m 0755 "$jellyNextDir"
    install -m 0644 ${jellyfinJellyNext}/Jellyfin.Plugin.JellyNext.deps.json "$jellyNextDir/"
    install -m 0644 ${jellyfinJellyNext}/Jellyfin.Plugin.JellyNext.dll "$jellyNextDir/"
    install -m 0644 ${jellyfinJellyNext}/Jellyfin.Plugin.JellyNext.pdb "$jellyNextDir/"
    install -m 0644 ${jellyfinJellyNext}/Jellyfin.Plugin.JellyNext.xml "$jellyNextDir/"

    traktDir=/var/lib/jellyfin/plugins/Trakt_30.0.0.0
    install -d -m 0755 "$traktDir"
    install -m 0644 ${jellyfinTrakt}/Trakt.dll "$traktDir/"

    if [ ! -f /var/lib/jellyfin/config/network.xml ]; then
      install -m 0644 /etc/jellyfin-network.xml /var/lib/jellyfin/config/network.xml
    fi
  '';
  services.suwayomi-server = {
    enable = true;
    openFirewall = true;
    package = mypkgs.suwayomi-server;
    settings.server = {
      ip = "0.0.0.0";
      port = 4567;
      extensionStores = ["https://raw.githubusercontent.com/keiyoushi/extensions/repo/index.min.json"];
      kcefEnabled = true;
      flareSolverrEnabled = true;
      flareSolverrUrl = "http://localhost:8191";
      basicAuthEnabled = true;
      basicAuthUsername = myvars.username;
      basicAuthPasswordFile = config.sops.secrets."suwayomi/basic-auth-password".path;
    };
  };
  services.minecraft-server = {
    enable = true;
    eula = true;
    openFirewall = true;
    jvmOpts = "-Xmx4G -Xms2G";
  };
  users.users.${myvars.username}.extraGroups = ["minecraft" "podman"];
  users.users."dtsf-2" = {
    isSystemUser = true;
    group = "users";
    home = "/home/dtsf-2";
    createHome = false;
  };
  systemd.services.filebrowser-dtsf2 = {
    description = "File Browser (dtsf-2)";
    after = ["network.target" "sops-nix.service"];
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      User = "dtsf-2";
      Group = "users";
      ExecStart = "${pkgs.filebrowser}/bin/filebrowser --port 8085 --address 127.0.0.1 --root /home/dtsf-2 --baseurl /dtsf-2 --database /var/lib/filebrowser-dtsf2/filebrowser.db";
      StateDirectory = "filebrowser-dtsf2";
      Restart = "on-failure";
    };
  };
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    defaultNetwork.settings.dns_enabled = true;
  };
  virtualisation.oci-containers = {
    backend = "podman";
    containers = {
      excalidraw = {
        image = "excalidraw/excalidraw:latest";
        ports = ["8083:80"];
      };
      flaresolverr = {
        image = "ghcr.io/flaresolverr/flaresolverr:latest";
        ports = ["127.0.0.1:8191:8191"];
        environment = {
          LOG_LEVEL = "info";
          TZ = "America/Sao_Paulo";
        };
      };
    };
  };
  services.tailscale = {
    enable = true;
    openFirewall = true;
  };
  services.qbittorrent = {
    enable = true;
    openFirewall = true;
    user = myvars.username;
    group = "users";
    webuiPort = 8081;
    torrentingPort = 6881;
    serverConfig.Preferences.Downloads.SavePath = "/home/${myvars.username}/downloads";
  };
  systemd.services.qbittorrent.serviceConfig = {
    ProtectHome = lib.mkForce false;
    ReadWritePaths = ["/home/${myvars.username}"];
  };
  services.vaultwarden = {
    enable = true;
    package = mypkgs.vaultwarden;
    config = {
      ROCKET_PORT = "8082";
      ROCKET_ADDRESS = "127.0.0.1";
      DOMAIN = "https://dtsf-server/vault";
    };
  };
  environment.systemPackages = [pkgs.cryptsetup pkgs.filebrowser];
  networking.firewall.allowedTCPPorts = [6881];
  networking.firewall.allowedUDPPorts = [6881];
}
