{
  config,
  lib,
  pkgs,
  myvars,
  ...
}: {
  system.activationScripts.custom-certs = lib.stringAfter ["setupSecrets"] ''
    mkdir -p /run/custom-certs
    cat ${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt ${config.sops.secrets."certs/server".path} > /run/custom-certs/ca-bundle.crt

    mkdir -p /home/${myvars.username}/.pki/nssdb
    ${pkgs.nssTools}/bin/certutil -d sql:/home/${myvars.username}/.pki/nssdb -A -t "C,," -n "dtsf-server" -i ${config.sops.secrets."certs/server".path}
    chown -R ${myvars.username}:users /home/${myvars.username}/.pki
  '';

  environment.variables = {
    SSL_CERT_FILE = "/run/custom-certs/ca-bundle.crt";
    NIX_SSL_CERT_FILE = "/run/custom-certs/ca-bundle.crt";
  };
}
