{ config, secrets, ... }:
let
  cert = config.security.acme.certs.${secrets.parents.domain};
in {
  services.sabnzbd = {
    enable = true;
    openFirewall = true;
    group = "starr";
  };

  services.nginx.virtualHosts = {
    "sabnzbd.${secrets.parents.domain}" = {
      forceSSL = true;
      sslCertificate = "${cert.directory}/fullchain.pem";
      sslCertificateKey = "${cert.directory}/key.pem";
      sslTrustedCertificate = "${cert.directory}/chain.pem";
      locations."/" = {
        proxyPass = "http://127.0.0.1:8080";
      };
    };
  };
}
