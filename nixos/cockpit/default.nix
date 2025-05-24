{ config, lib, secrets, ... }:
let
  cert = config.security.acme.certs.${secrets.parents.domain};
in {
  services.cockpit = {
    enable = true;
    openFirewall = true;
    settings = {
      WebService = {
        AllowUnencrypted = true;
        ProtocolHeader = "X-Forwarded-Proto";
        Origins = lib.mkForce (lib.concatStringsSep " " [
          "http://127.0.0.1:${builtins.toString config.services.cockpit.port}"
          "http://guiltyspark:${builtins.toString config.services.cockpit.port}"
          "https://cockpit.${secrets.parents.domain}"
        ]);
      };
    };
  };

  services.nginx.virtualHosts = {
    "cockpit.${secrets.parents.domain}" = {
      forceSSL = true;
      sslCertificate = "${cert.directory}/fullchain.pem";
      sslCertificateKey = "${cert.directory}/key.pem";
      sslTrustedCertificate = "${cert.directory}/chain.pem";
      locations."/" = {
        proxyPass = "http://127.0.0.1:9090";
        proxyWebsockets = true;
        extraConfig = /* nginx */ ''
          gzip off;
        '';
      };
    };
  };
}
