{ config, secrets, ... }:
let
  cert = config.security.acme.certs.${secrets.parents.domain};
in {
  services.jellyfin = {
    enable = true;
    openFirewall = true;
  };

  services.nginx.virtualHosts = {
    "jellyfin.${secrets.parents.domain}" = {
      forceSSL = true;
      sslCertificate = "${cert.directory}/fullchain.pem";
      sslCertificateKey = "${cert.directory}/key.pem";
      sslTrustedCertificate = "${cert.directory}/chain.pem";
      locations."/" = {
        proxyPass = "http://127.0.0.1:8096";
      };
    };
  };
}
