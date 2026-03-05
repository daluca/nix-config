{ config, secrets }:
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
  "paperless.${secrets.domain.general}" = tls // {
    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString paperless.port}";
    };
  };

  "redlib.${secrets.domain.general}" = tls // {
    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString redlib.port}";
    };
  };

  "navidrome.${secrets.domain.general}" = tls // {
    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString navidrome.settings.Port}";
    };
  };

  "home-assistant.${secrets.domain.general}" = tls // {
    locations."/" = {
      proxyPass = "http://10.1.1.12:8123";
      proxyWebsockets = true;
    };
  };

  "zigbee2mqtt.${secrets.domain.general}" = tls // {
    locations."/" = {
      proxyPass = "http://10.1.1.12:8099";
      proxyWebsockets = true;
    };
  };

  ${firefly-iii.virtualHost} = tls;

  ${firefly-iii-data-importer.virtualHost} = tls;
}
