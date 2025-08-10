{ config, secrets, ... }:
let
  cert = config.security.acme.certs.${secrets.parents.domain};
in rec {
  services.qbittorrent = {
    enable = true;
    webuiPort = 8081;
    openFirewall = true;
  };

  services.nginx.virtualHosts = {
    "qbittorrent.${secrets.parents.domain}" = {
      forceSSL = true;
      sslCertificate = "${cert.directory}/fullchain.pem";
      sslCertificateKey = "${cert.directory}/key.pem";
      sslTrustedCertificate = "${cert.directory}/chain.pem";
      locations."/" = {
        proxyPass = "http://127.0.0.1:${builtins.toString services.qbittorrent.webuiPort}";
      };
    };
  };
}
