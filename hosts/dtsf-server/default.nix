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
    openFirewall = true;
    settings = {
      port = 8080;
      root = "/home/${myvars.username}";
      address = "0.0.0.0";
    };
  };

  services.jellyfin = {
    enable = true;
    openFirewall = true;
    user = myvars.username;
  };

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

  # Vaultwarden reverse proxy for HTTPS support
  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    virtualHosts."vault.dtsf-server" = {
      listen = [{addr = "0.0.0.0"; port = 8443; ssl = true;}];
      forceSSL = false;
      enableACME = false;
      sslCertificate = "/var/lib/vaultwarden-ssl/vault.crt";
      sslCertificateKey = "/var/lib/vaultwarden-ssl/vault.key";

      locations."/" = {
        proxyPass = "http://127.0.0.1:8082";
        proxyWebsockets = true;
        extraConfig = ''
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header X-Forwarded-Proto $scheme;
        '';
      };
    };
  };

  # Generate self-signed certificate for Vaultwarden
  systemd.services.vaultwarden-ssl-cert = {
    description = "Generate self-signed SSL certificate for Vaultwarden";
    wantedBy = ["multi-user.target"];
    before = ["nginx.service"];
    script = ''
      CERT_DIR="/var/lib/vaultwarden-ssl"
      mkdir -p "$CERT_DIR"

      if [ ! -f "$CERT_DIR/vault.key" ]; then
        ${pkgs.openssl}/bin/openssl req -x509 -newkey rsa:4096 \
          -keyout "$CERT_DIR/vault.key" \
          -out "$CERT_DIR/vault.crt" \
          -days 3650 -nodes \
          -subj "/CN=vault.dtsf-server" \
          -addext "subjectAltName=DNS:vault.dtsf-server,DNS:dtsf-server,IP:192.168.31.212"

        chmod 600 "$CERT_DIR/vault.key"
        chmod 644 "$CERT_DIR/vault.crt"
        chown -R nginx:nginx "$CERT_DIR"
      fi
    '';
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
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
        DOMAIN = "localhost";
      };
      service = {
        DISABLE_REGISTRATION = true;
      };
    };
  };

  services.vaultwarden = {
    enable = true;
    config = {
      ROCKET_PORT = "8082";
      ROCKET_ADDRESS = "0.0.0.0";
    };
  };

  services.homepage-dashboard = {
    enable = true;
    openFirewall = true;
    listenPort = 8084;
    allowedHosts = "localhost,dtsf-server,dtsf-server.local,192.168.31.212";
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
              href = "http://dtsf-server:8096";
              description = "Media server";
            };
          }
          {
            Minecraft = {
              icon = "minecraft.png";
              href = "http://dtsf-server:25565";
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
              href = "http://dtsf-server:8080";
              description = "File management";
            };
          }
          {
            qBittorrent = {
              icon = "qbittorrent.png";
              href = "http://dtsf-server:8081";
              description = "Torrent client";
            };
          }
          {
            Vaultwarden = {
              icon = "bitwarden.png";
              href = "https://dtsf-server:8443";
              description = "Password manager (HTTPS)";
            };
          }
          {
            Forgejo = {
              icon = "forgejo.png";
              href = "http://dtsf-server:3000";
              description = "Git server (notes)";
            };
          }
          {
            Excalidraw = {
              icon = "excalidraw.png";
              href = "http://dtsf-server:8083";
              description = "Collaborative whiteboard";
            };
          }
        ];
      }
    ];
  };

  networking.firewall.allowedTCPPorts = [
    3000 # forgejo
    8080 # filebrowser
    8081 # qbittorrent
    8082 # vaultwarden http
    8083 # excalidraw
    8084 # homepage
    8096 # jellyfin
    8443 # vaultwarden https (via nginx)
  ];

  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;

  system.stateVersion = "25.11";
}
