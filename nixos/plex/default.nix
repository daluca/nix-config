{ config, pkgs, secrets, ... }:
let
  cert = config.security.acme.certs.${secrets.parents.domain};
in {
  services.plex = {
    enable = true;
    package = pkgs.unstable.plex;
    openFirewall = true;
  };

  services.nginx.virtualHosts = {
    "plex.${secrets.parents.domain}" = {
      forceSSL = true;
      sslCertificate = "${cert.directory}/fullchain.pem";
      sslCertificateKey = "${cert.directory}/key.pem";
      sslTrustedCertificate = "${cert.directory}/chain.pem";
      locations."/" = {
        proxyPass = "http://127.0.0.1:32400";
      };
    };
  };
}
