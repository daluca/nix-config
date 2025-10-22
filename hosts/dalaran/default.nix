{ config, lib, secrets, inputs, ... }:

{
  imports = with inputs; [
    disko.nixosModules.disko

    ./disko.nix
    ./adguardhome.nix
  ] ++ map (m: lib.custom.relativeToRoot m) [
    "images/raspberry-pi/5"
  ] ++ map (m: lib.custom.relativeToHosts m) [
    "."
  ] ++ map (m: lib.custom.relativeToUsers m) [
    "remotebuild"
  ] ++ map (m: lib.custom.relativeToNixosModules m) [
    "openssh/server"
    "nginx"
    "adguardhome"
    "paperless"
    "redlib"
    "home-assistant"
    "firefly-iii"
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
  in {
    "paperless.${secrets.domain.general}" = tls // {
      locations."/" = {
        proxyPass = "http://127.0.0.1:${builtins.toString config.services.paperless.port}";
      };
    };
    "redlib.${secrets.domain.general}" = tls // {
      locations."/" = {
        proxyPass = "http://127.0.0.1:${builtins.toString config.services.redlib.port}";
      };
      locations."/dns-query" = {
        proxyPass = "http://127.0.0.1:${builtins.toString config.services.redlib.port}";
      };
    };
    "home-assistant.${secrets.domain.general}" = tls // {
      locations."/" = {
        proxyPass = "http://127.0.0.1:${builtins.toString config.services.home-assistant.config.http.server_port}";
        proxyWebsockets = true;
      };
    };
    "${config.services.firefly-iii.virtualHost}" = tls;
    "${config.services.firefly-iii-data-importer.virtualHost}" = tls;
  };

  services.paperless.settings = {
    PAPERLESS_URL = "https://paperless.${secrets.domain.general}";
  };

  services.firefly-iii.virtualHost = "firefly.${secrets.domain.general}";

  services.firefly-iii-data-importer.virtualHost = "firefly-importer.${secrets.domain.general}";

  networking.hostName = "dalaran";

  hardware.raspberry-pi.config = {
    all.base-dt-params = {
      pciex1_gen = {
        enable = true;
        value = 3;
      };
    };
  };

  system.stateVersion = "25.05";
}
