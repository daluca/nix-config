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
    "openthread-border-router.${secrets.domain.general}" = tls // {
      locations."/" = {
        proxyPass = "http://127.0.0.1:${builtins.toString openthread-border-router.web.listenPort}";
      };
    };
    "zigbee2mqtt.${secrets.domain.general}" = tls // {
      locations."/" = {
        proxyPass = "http://127.0.0.1:${builtins.toString zigbee2mqtt.settings.frontend.port}";
        proxyWebsockets = true;
      };
    };
  };

  services.openthread-border-router = {
    backboneInterface = "end0";
    radio.device = "/dev/serial/by-id/usb-Nabu_Casa_ZBT-2_1CDBD45CFA64-if00";
  };

  services.zigbee2mqtt.settings = {
    frontend.url = "https://zigbee2mqtt.${secrets.domain.general}/";
    serial.port = "/dev/serial/by-id/usb-Nabu_Casa_Home_Assistant_Connect_ZBT-1_3a9311746212f01186e40514773d9da9-if00-port0";
  };

  networking.hostName = "homeassistant";

  system.stateVersion = "25.11";
}
