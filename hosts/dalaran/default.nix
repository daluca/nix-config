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
  ];

  security.acme.certs.${secrets.domain.general}.domain = "*.${secrets.domain.general}";

  services.nginx.virtualHosts =
  let
    cert = config.security.acme.certs.${secrets.domain.general};
    sslCertificate = "${cert.directory}/fullchain.pem";
    sslCertificateKey = "${cert.directory}/key.pem";
    sslTrustedCertificate = "${cert.directory}/chain.pem";
  in {
    "paperless.${secrets.domain.general}" = {
      inherit sslCertificate sslCertificateKey sslTrustedCertificate;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:${builtins.toString config.services.paperless.port}";
      };
    };
  };

  services.paperless.settings = {
    PAPERLESS_URL = "https://paperless.${secrets.domain.general}";
  };

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
