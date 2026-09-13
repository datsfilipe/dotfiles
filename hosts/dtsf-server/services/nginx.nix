{pkgs, ...}: let
  proxyHeaders = ''
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
    proxy_set_header X-Forwarded-Host $host;
  '';
  mkProxyLocation = proxyPass: extraConfig: {
    inherit proxyPass;
    proxyWebsockets = true;
    extraConfig = proxyHeaders + extraConfig;
  };
in {
  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    virtualHosts."dtsf-server" = {
      forceSSL = true;
      enableACME = false;
      sslCertificate = "/var/lib/acme/dtsf-server/cert.pem";
      sslCertificateKey = "/var/lib/acme/dtsf-server/key.pem";
      locations = {
        "/" = {
          proxyPass = "http://127.0.0.1:8084";
          proxyWebsockets = true;
          priority = 100;
        };
        "/jellyfin/" = mkProxyLocation "http://127.0.0.1:8096/jellyfin/" "proxy_buffering off;";
        "/files".return = "301 https://$host/files/";
        "/files/" = mkProxyLocation "http://127.0.0.1:8080/files/" "";
        "/dtsf-2".return = "301 https://$host/dtsf-2/";
        "/dtsf-2/" = mkProxyLocation "http://127.0.0.1:8085/dtsf-2/" "";
        "/vault".return = "301 https://$host/vault/";
        "/vault/" = mkProxyLocation "http://127.0.0.1:8082/vault/" "";
        "/draw".return = "301 https://$host/draw/";
        "/draw/" = {
          proxyPass = "http://127.0.0.1:8083/";
          proxyWebsockets = true;
          extraConfig = ''
            proxy_set_header Accept-Encoding "";
            sub_filter 'href="/' 'href="/draw/';
            sub_filter 'src="/' 'src="/draw/';
            sub_filter_once off;
          '';
        };
        "/torrent".return = "301 https://$host/torrent/";
        "/torrent/" = mkProxyLocation "http://127.0.0.1:8081/" ''
          proxy_cookie_path / "/torrent/";
        '';
      };
    };
  };

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

  networking.firewall.allowedTCPPorts = [443];
}
