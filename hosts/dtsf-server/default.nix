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
    useRoutingFeatures = "both";
  };

  # Tailscale HTTPS certificates
  security.acme = {
    acceptTerms = true;
    defaults.email = "contact@datsfilipe.xyz"; # Change if needed
  };

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    virtualHosts = {
      "dtsf-server" = {
        forceSSL = true;
        enableACME = false;
        sslCertificate = "/var/lib/tailscale/certs/dtsf-server.ts.net.crt";
        sslCertificateKey = "/var/lib/tailscale/certs/dtsf-server.ts.net.key";

        locations."/" = {
          proxyPass = "http://127.0.0.1:8084"; # Homepage
          proxyWebsockets = true;
        };
      };

      "jellyfin.dtsf-server" = {
        forceSSL = true;
        enableACME = false;
        sslCertificate = "/var/lib/tailscale/certs/dtsf-server.ts.net.crt";
        sslCertificateKey = "/var/lib/tailscale/certs/dtsf-server.ts.net.key";

        locations."/" = {
          proxyPass = "http://127.0.0.1:8096";
          proxyWebsockets = true;
        };
      };

      "files.dtsf-server" = {
        forceSSL = true;
        enableACME = false;
        sslCertificate = "/var/lib/tailscale/certs/dtsf-server.ts.net.crt";
        sslCertificateKey = "/var/lib/tailscale/certs/dtsf-server.ts.net.key";

        locations."/" = {
          proxyPass = "http://127.0.0.1:8080";
          proxyWebsockets = true;
        };
      };

      "vault.dtsf-server" = {
        forceSSL = true;
        enableACME = false;
        sslCertificate = "/var/lib/tailscale/certs/dtsf-server.ts.net.crt";
        sslCertificateKey = "/var/lib/tailscale/certs/dtsf-server.ts.net.key";

        locations."/" = {
          proxyPass = "http://127.0.0.1:8082";
          proxyWebsockets = true;
        };
      };

      "git.dtsf-server" = {
        forceSSL = true;
        enableACME = false;
        sslCertificate = "/var/lib/tailscale/certs/dtsf-server.ts.net.crt";
        sslCertificateKey = "/var/lib/tailscale/certs/dtsf-server.ts.net.key";

        locations."/" = {
          proxyPass = "http://127.0.0.1:3000";
          proxyWebsockets = true;
        };
      };

      "draw.dtsf-server" = {
        forceSSL = true;
        enableACME = false;
        sslCertificate = "/var/lib/tailscale/certs/dtsf-server.ts.net.crt";
        sslCertificateKey = "/var/lib/tailscale/certs/dtsf-server.ts.net.key";

        locations."/" = {
          proxyPass = "http://127.0.0.1:8083";
          proxyWebsockets = true;
        };
      };

      "torrent.dtsf-server" = {
        forceSSL = true;
        enableACME = false;
        sslCertificate = "/var/lib/tailscale/certs/dtsf-server.ts.net.crt";
        sslCertificateKey = "/var/lib/tailscale/certs/dtsf-server.ts.net.key";

        locations."/" = {
          proxyPass = "http://127.0.0.1:8081";
          proxyWebsockets = true;
        };
      };
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
    allowedHosts = "localhost,dtsf-server";
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
              href = "https://jellyfin.dtsf-server";
              description = "Media server";
            };
          }
          {
            Minecraft = {
              icon = "minecraft.png";
              href = "http://localhost:25565";
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
              href = "https://files.dtsf-server";
              description = "File management";
            };
          }
          {
            qBittorrent = {
              icon = "qbittorrent.png";
              href = "https://torrent.dtsf-server";
              description = "Torrent client";
            };
          }
          {
            Vaultwarden = {
              icon = "bitwarden.png";
              href = "https://vault.dtsf-server";
              description = "Password manager";
            };
          }
          {
            Forgejo = {
              icon = "forgejo.png";
              href = "https://git.dtsf-server";
              description = "Git server (notes)";
            };
          }
          {
            Excalidraw = {
              icon = "excalidraw.png";
              href = "https://draw.dtsf-server";
              description = "Collaborative whiteboard";
            };
          }
        ];
      }
    ];
  };

  networking.firewall.allowedTCPPorts = [
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
