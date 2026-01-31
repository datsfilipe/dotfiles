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

  # Caddy reverse proxy with automatic HTTPS and path-based routing
  services.caddy = {
    enable = true;
    globalConfig = ''
      auto_https disable_redirects
      local_certs
    '';
    virtualHosts."dtsf-server".extraConfig = ''
      tls internal

      # Services with path stripping
      handle_path /jellyfin* {
        reverse_proxy localhost:8096
      }

      handle_path /files* {
        reverse_proxy localhost:8080
      }

      handle_path /vault* {
        reverse_proxy localhost:8082
      }

      handle_path /git* {
        reverse_proxy localhost:3000
      }

      handle_path /draw* {
        reverse_proxy localhost:8083
      }

      handle_path /torrent* {
        reverse_proxy localhost:8081
      }

      # Homepage at root (must be last)
      handle {
        reverse_proxy localhost:8084
      }
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

  networking.firewall.allowedTCPPorts = [
    443  # caddy https
    3000 # forgejo (backend)
    8080 # filebrowser (backend)
    8081 # qbittorrent (backend)
    8082 # vaultwarden (backend)
    8083 # excalidraw (backend)
    8084 # homepage (backend)
    8096 # jellyfin (backend)
  ];

  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;

  system.stateVersion = "25.11";
}
