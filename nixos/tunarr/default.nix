{ config, secrets, ... }:
let
  cert = config.security.acme.certs.${secrets.parents.domain};
in rec {
  services.tunarr = {
    enable = true;
    port = 8108;
    settings = {
      settings.xmltv.programmingHours = 7 * 24;
    };
  };

  services.nginx.virtualHosts = {
    "tunarr.${secrets.parents.domain}" = {
      forceSSL = true;
      sslCertificate = "${cert.directory}/fullchain.pem";
      sslCertificateKey = "${cert.directory}/key.pem";
      sslTrustedCertificate = "${cert.directory}/chain.pem";
      locations."/" = {
        proxyPass = "http://127.0.0.1:${builtins.toString services.tunarr.port}";
      };
    };
  };
}
