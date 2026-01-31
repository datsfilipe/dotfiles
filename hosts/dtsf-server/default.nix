{
  pkgs,
  lib,
  mylib,
  myvars,
  ...
}: let
  hostName = "dtsf-server";
in {
  imports =
    [./hardware-configuration.nix ./boot.nix]
    ++ (mylib.file.scanPaths ../../modules "os.nix");

  networking = {
    inherit hostName;
    networkmanager.enable = true;
  };

  # Enable core modules
  modules.core.boot.system.enable = true;
  modules.core.nix.system.enable = true;
  modules.core.security.system.enable = true;
  modules.core.user.system.enable = true;
  modules.core.system.enable = true;
  modules.core.shell.fish.system.enable = true;
  modules.core.shell.ssh.system.enable = true;
  modules.core.misc.ssh-manager.enable = true;

  modules.editors.neovim.system.enable = true;

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

  # Configure Jellyfin base URL
  systemd.services.jellyfin.preStart = ''
    mkdir -p /var/lib/jellyfin/config
    if [ ! -f /var/lib/jellyfin/config/network.xml ]; then
      cat > /var/lib/jellyfin/config/network.xml <<EOF
<?xml version="1.0" encoding="utf-8"?>
<NetworkConfiguration xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
  <BaseUrl>/jellyfin</BaseUrl>
</NetworkConfiguration>
EOF
      chown -R jellyfin:jellyfin /var/lib/jellyfin/config
    fi
  '';

  services.minecraft-server = {
    enable = true;
    eula = true;
    openFirewall = true; # port 25565
    jvmOpts = "-Xmx4G -Xms2G";
  };

  users.users.${myvars.username}.extraGroups = ["minecraft" "podman"];

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
    };
  };

  services.tailscale = {
    enable = true;
    openFirewall = true;
  };

  # Caddy for HTTPS with self-signed certificates on port 443 only
  services.caddy = {
    enable = true;
    globalConfig = ''
      auto_https disable_redirects
      local_certs
    '';

    virtualHosts."dtsf-server".extraConfig = ''
      tls internal

      # Jellyfin (handles /jellyfin internally via BaseUrl)
      reverse_proxy /jellyfin/* localhost:8096

      # Filebrowser (configured with baseURL)
      reverse_proxy /files/* localhost:8080

      # Vaultwarden (configured with DOMAIN)
      reverse_proxy /vault/* localhost:8082

      # Forgejo (configured with ROOT_URL)
      reverse_proxy /git/* localhost:3000

      # Excalidraw (direct proxy, no base path support)
      handle_path /draw* {
        reverse_proxy localhost:8083
      }

      # qBittorrent (check if it needs special config)
      handle_path /torrent* {
        reverse_proxy localhost:8081
      }

      # Homepage at root
      reverse_proxy localhost:8084
    '';
  };

  services.qbittorrent = {
    enable = true;
    openFirewall = true;
    user = myvars.username;
    group = "users";
    webuiPort = 8081;
  };

  services.forgejo = {
    enable = true;
    settings = {
      server = {
        HTTP_PORT = 3000;
        DOMAIN = "dtsf-server";
        ROOT_URL = "https://dtsf-server/git/";
      };
      service = {
        DISABLE_REGISTRATION = false; # Set to true after creating admin
      };
    };
  };

  services.vaultwarden = {
    enable = true;
    config = {
      ROCKET_PORT = "8082";
      ROCKET_ADDRESS = "127.0.0.1";
      DOMAIN = "https://dtsf-server/vault";
    };
  };

  services.homepage-dashboard = {
    enable = true;
    openFirewall = true;
    listenPort = 8084;
    allowedHosts = "localhost,dtsf-server,192.168.31.212";
    settings = {
      title = "dtsf-server";
      layout = [
        {
          Media = {
            style = "row";
            columns = 2;
          };
        }
        {
          Services = {
            style = "row";
            columns = 2;
          };
        }
      ];
    };
    services = [
      {
        Media = [
          {
            Jellyfin = {
              icon = "jellyfin.png";
              href = "https://dtsf-server/jellyfin";
              description = "Media server";
            };
          }
          {
            Minecraft = {
              icon = "minecraft.png";
              href = "minecraft://dtsf-server:25565";
              description = "Minecraft server";
            };
          }
        ];
      }
      {
        Services = [
          {
            "File Browser" = {
              icon = "filebrowser.png";
              href = "https://dtsf-server/files";
              description = "File management";
            };
          }
          {
            qBittorrent = {
              icon = "qbittorrent.png";
              href = "https://dtsf-server/torrent";
              description = "Torrent client";
            };
          }
          {
            Vaultwarden = {
              icon = "bitwarden.png";
              href = "https://dtsf-server/vault";
              description = "Password manager";
            };
          }
          {
            Forgejo = {
              icon = "forgejo.png";
              href = "https://dtsf-server/git";
              description = "Git server (notes)";
            };
          }
          {
            Excalidraw = {
              icon = "excalidraw.png";
              href = "https://dtsf-server/draw";
              description = "Collaborative whiteboard";
            };
          }
        ];
      }
    ];
  };

  networking.firewall.allowedTCPPorts = [
    443  # caddy HTTPS
  ];

  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;

  system.stateVersion = "25.11";
}
