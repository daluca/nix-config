{ config, secrets, ... }:
let
  cert = config.security.acme.certs.${secrets.parents.domain};
in {
  services.jellyseerr = {
    enable = true;
    openFirewall = true;
  };

  services.nginx.virtualHosts = {
    "request.${secrets.parents.domain}" = {
      forceSSL = true;
      sslCertificate = "${cert.directory}/fullchain.pem";
      sslCertificateKey = "${cert.directory}/key.pem";
      sslTrustedCertificate = "${cert.directory}/chain.pem";
      locations."/" = {
        proxyPass = "http://127.0.0.1:5055";
      };
    };
    "requests.${secrets.parents.domain}" = {
      forceSSL = true;
      sslCertificate = "${cert.directory}/fullchain.pem";
      sslCertificateKey = "${cert.directory}/key.pem";
      sslTrustedCertificate = "${cert.directory}/chain.pem";
      locations."/".return = ''
        301 $scheme://request.${secrets.parents.domain}$request_uri
      '';
    };
  };
}
