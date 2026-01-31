{
  pkgs,
  lib,
  myvars,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./boot.nix
  ];

  networking.hostName = "dtsf-server";

  services.filebrowser = {
    enable = true;
    port = 8080;
    user = myvars.username;
    group = "users";
    root = "/home/${myvars.username}";
    openFirewall = true;
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
      ROCKET_PORT = 8082;
      ROCKET_ADDRESS = "0.0.0.0";
    };
  };

  services.homepage-dashboard = {
    enable = true;
    openFirewall = true;
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
              href = "http://localhost:8096";
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
              href = "http://localhost:8080";
              description = "File management";
            };
          }
          {
            qBittorrent = {
              icon = "qbittorrent.png";
              href = "http://localhost:8081";
              description = "Torrent client";
            };
          }
          {
            Vaultwarden = {
              icon = "bitwarden.png";
              href = "http://localhost:8082";
              description = "Password manager";
            };
          }
          {
            Forgejo = {
              icon = "forgejo.png";
              href = "http://localhost:3000";
              description = "Git server (notes)";
            };
          }
          {
            Excalidraw = {
              icon = "excalidraw.png";
              href = "http://localhost:8083";
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
}
