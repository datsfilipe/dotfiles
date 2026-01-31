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

  # mDNS for local hostname resolution
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    publish = {
      enable = true;
      addresses = true;
      domain = true;
      workstation = true;
    };
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

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    # Default server with self-signed cert for IP and hostname access
    virtualHosts."_" = {
      default = true;
      forceSSL = true;
      enableACME = false;
      sslCertificate = "/var/lib/nginx/certs/dtsf-server.crt";
      sslCertificateKey = "/var/lib/nginx/certs/dtsf-server.key";

      # Route based on port via SNI or use path-based routing
      locations."/" = {
        proxyPass = "http://127.0.0.1:8084"; # Homepage dashboard
        proxyWebsockets = true;
      };

      locations."/jellyfin/" = {
        proxyPass = "http://127.0.0.1:8096/";
        proxyWebsockets = true;
      };

      locations."/files/" = {
        proxyPass = "http://127.0.0.1:8080/";
        proxyWebsockets = true;
      };

      locations."/vault/" = {
        proxyPass = "http://127.0.0.1:8082/";
        proxyWebsockets = true;
        extraConfig = ''
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header X-Forwarded-Proto $scheme;
        '';
      };

      locations."/git/" = {
        proxyPass = "http://127.0.0.1:3000/";
        proxyWebsockets = true;
      };

      locations."/draw/" = {
        proxyPass = "http://127.0.0.1:8083/";
        proxyWebsockets = true;
      };

      locations."/torrent/" = {
        proxyPass = "http://127.0.0.1:8081/";
        proxyWebsockets = true;
      };
    };
  };

  # Generate self-signed certificate on first boot
  systemd.services.nginx-ssl-cert = {
    description = "Generate self-signed SSL certificate for nginx";
    wantedBy = ["multi-user.target"];
    before = ["nginx.service"];
    script = ''
      CERT_DIR="/var/lib/nginx/certs"
      mkdir -p "$CERT_DIR"

      if [ ! -f "$CERT_DIR/dtsf-server.key" ]; then
        ${pkgs.openssl}/bin/openssl req -x509 -newkey rsa:4096 \
          -keyout "$CERT_DIR/dtsf-server.key" \
          -out "$CERT_DIR/dtsf-server.crt" \
          -days 3650 -nodes \
          -subj "/CN=dtsf-server" \
          -addext "subjectAltName=DNS:dtsf-server,DNS:dtsf-server.local,IP:192.168.31.212"

        chmod 600 "$CERT_DIR/dtsf-server.key"
        chmod 644 "$CERT_DIR/dtsf-server.crt"
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
              href = "https://dtsf-server/jellyfin";
              description = "Media server";
            };
          }
          {
            Minecraft = {
              icon = "minecraft.png";
              href = "http://192.168.31.212:25565";
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
    80   # nginx http (redirects to https)
    443  # nginx https
    3000 # forgejo
    8082 # vaultwarden
    8083 # excalidraw
  ];

  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;

  system.stateVersion = "25.11";
}
