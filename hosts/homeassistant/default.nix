{ config, lib, secrets, nixos-raspberrypi, ... }:

{
  imports = [
    nixos-raspberrypi.nixosModules.sd-image
  ] ++ [
    ./..
  ] ++ map (m: lib.custom.relativeToRoot m) [
    "images/raspberry-pi/5"
  ] ++ map (m: lib.custom.relativeToNixosModules m) [
    "openssh/server"
    "home-assistant"
    "nginx"
  ];

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
  in with config.services; {
    "home-assistant.${secrets.domain.general}" = tls // {
      locations."/" = {
        proxyPass = "http://127.0.0.1:${builtins.toString home-assistant.config.http.server_port}";
        proxyWebsockets = true;
      };
    };
  };

  networking.hostName = "homeassistant";

  system.stateVersion = "25.11";
}
