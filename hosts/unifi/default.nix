{ config, lib, secrets, ... }:

{
  imports = [
    ./..
  ] ++ map (m: lib.custom.relativeToRoot m) [
    "images/digitalocean"
  ] ++ map (m: lib.custom.relativeToNixosModules m) [
    "openssh/server"
    "unifi-controller"
    "nginx"
  ];

  networking.hostName = "unifi";
  networking.enableIPv6 = false;

  security.acme.certs.${secrets.domain.general}.domain = "*.${secrets.domain.general}";

  services.nginx.virtualHosts =
  let
    cert = config.security.acme.certs.${secrets.domain.general};
    sslCertificate = "${cert.directory}/fullchain.pem";
    sslCertificateKey = "${cert.directory}/key.pem";
    sslTrustedCertificate = "${cert.directory}/chain.pem";
    tls = {
      inherit sslCertificate sslCertificateKey sslTrustedCertificate;
      forceSSL = true;
    };
  in {
    "unifi.${secrets.domain.general}" = tls // {
      locations."/" = {
        proxyPass = "https://127.0.0.1:8443";
      };
      locations."/ws" = {
        proxyPass = "https://127.0.0.1:8443";
        proxyWebsockets = true;
        extraConfig = /* nginx */ ''
          proxy_ssl_verify off;
        '';
      };
    };
  };

  system.stateVersion = "25.11";
}
