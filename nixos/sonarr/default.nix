{ config, secrets, ... }:
let
  cert = config.security.acme.certs.${secrets.parents.domain};
in {
  services.sonarr = {
    enable = true;
    openFirewall = true;
    group = "starr";
  };

  services.nginx.virtualHosts = {
    "sonarr.${secrets.parents.domain}" = {
      forceSSL = true;
      sslCertificate = "${cert.directory}/fullchain.pem";
      sslCertificateKey = "${cert.directory}/key.pem";
      sslTrustedCertificate = "${cert.directory}/chain.pem";
      locations."/" = {
        proxyPass = "http://127.0.0.1:8989";
      };
    };
  };
}
