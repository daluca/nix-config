{
  flake.nixosModules.cockpit =
    {
      config,
      lib,
      secrets,
      ...
    }:
    {
      services.cockpit = {
        enable = true;
        openFirewall = true;
        settings = {
          WebService = {
            AllowUnencrypted = true;
            ProtocolHeader = "X-Forwarded-Proto";
            Origins = lib.mkForce (
              lib.concatStringsSep " " [
                "http://127.0.0.1:${toString config.services.cockpit.port}"
                "http://guiltyspark:${toString config.services.cockpit.port}"
                "https://cockpit.${secrets.parents.domain}"
              ]
            );
          };
        };
      };

      services.nginx.virtualHosts =
        let
          cert = config.security.acme.certs.${secrets.parents.domain};
          sslCertificate = "${cert.directory}/fullchain.pem";
          sslCertificateKey = "${cert.directory}/key.pem";
          sslTrustedCertificate = "${cert.directory}/chain.pem";
          tls = {
            inherit sslCertificate sslCertificateKey sslTrustedCertificate;
            forceSSL = true;
          };
        in
        {
          "cockpit.${secrets.parents.domain}" = tls // {
            locations."/" = {
              proxyPass = "http://127.0.0.1:9090";
              proxyWebsockets = true;
              extraConfig = /* nginx */ ''
                gzip off;
              '';
            };
          };
        };
    };
}
