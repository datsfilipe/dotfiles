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

  # Configure Jellyfin base URL - create network.xml if missing
  systemd.tmpfiles.rules = [
    "d /var/lib/jellyfin/config 0755 ${myvars.username} users -"
  ];

  environment.etc."jellyfin-network.xml".text = ''
    <?xml version="1.0" encoding="utf-8"?>
    <NetworkConfiguration xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
      <BaseUrl>/jellyfin</BaseUrl>
    </NetworkConfiguration>
  '';

  systemd.services.jellyfin.preStart = ''
    if [ ! -f /var/lib/jellyfin/config/network.xml ]; then
      cp /etc/jellyfin-network.xml /var/lib/jellyfin/config/network.xml
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

  # nginx with HTTPS for reverse proxy
  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    virtualHosts."dtsf-server" = {
      forceSSL = true;
      enableACME = false;
      sslCertificate = "/var/lib/acme/dtsf-server/cert.pem";
      sslCertificateKey = "/var/lib/acme/dtsf-server/key.pem";

      locations."/" = {
        proxyPass = "http://127.0.0.1:8084";
        proxyWebsockets = true;
        priority = 100;
      };

      locations."/jellyfin/" = {
        proxyPass = "http://127.0.0.1:8096/jellyfin/";
        proxyWebsockets = true;
        extraConfig = ''
          proxy_buffering off;
        '';
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
        extraConfig = ''
          proxy_set_header Accept-Encoding "";
          sub_filter 'href="/' 'href="/draw/';
          sub_filter 'src="/' 'src="/draw/';
          sub_filter_once off;
        '';
      };

      locations."/torrent/" = {
        proxyPass = "http://127.0.0.1:8081/";
        proxyWebsockets = true;
      };
    };
  };

  # Generate self-signed certificate before nginx starts
  systemd.services.nginx.preStart = ''
    CERT_DIR="/var/lib/acme/dtsf-server"
    mkdir -p "$CERT_DIR"

    if [ ! -f "$CERT_DIR/key.pem" ]; then
      ${pkgs.openssl}/bin/openssl req -x509 -newkey rsa:4096 \
        -keyout "$CERT_DIR/key.pem" \
        -out "$CERT_DIR/cert.pem" \
        -days 3650 -nodes \
        -subj "/CN=dtsf-server" \
        -addext "subjectAltName=DNS:dtsf-server,IP:192.168.31.212"

      chmod 640 "$CERT_DIR/key.pem"
      chmod 644 "$CERT_DIR/cert.pem"
      chown root:nginx "$CERT_DIR/key.pem"
    fi
  '';

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
    };
  };

  networking.firewall.allowedTCPPorts = [
    443 # nginx HTTPS
  ];

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

  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;

  system.stateVersion = "25.11";
}
