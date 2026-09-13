{
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
              href = "https://dtsf-server/jellyfin/";
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
          {
            Suwayomi = {
              icon = "suwayomi.png";
              href = "http://dtsf-server:4567";
              description = "Manga reader server";
            };
          }
        ];
      }
      {
        Services = [
          {
            "File Browser" = {
              icon = "filebrowser.png";
              href = "https://dtsf-server/files/";
              description = "File management";
            };
          }
          {
            qBittorrent = {
              icon = "qbittorrent.png";
              href = "https://dtsf-server/torrent/";
              description = "Torrent client";
            };
          }
          {
            Vaultwarden = {
              icon = "bitwarden.png";
              href = "https://dtsf-server/vault/";
              description = "Password manager";
            };
          }
          {
            Excalidraw = {
              icon = "excalidraw.png";
              href = "https://dtsf-server/draw/";
              description = "Collaborative whiteboard";
            };
          }
        ];
      }
    ];
  };
}
