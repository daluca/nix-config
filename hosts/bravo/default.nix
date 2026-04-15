{ config, lib, secrets, outputs, ... }:

{
  imports = with outputs.nixosModules; [
    ./..
    ./disko.nix

    hetzner-cloud-arm
  ] ++ map (m: lib.custom.relativeToUsers m) [
    "remotebuild"
  ] ++ map (m: lib.custom.relativeToNixosModules m) [
    "impermanence/grub"
    "remote-unlocking/dhcp"
    "nginx"
    "ntfy-sh"
    "atuin"
  ];

  services.ntfy-sh.settings.base-url = "https://ntfy.${secrets.cloud.domain}";

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
    "ntfy.${secrets.domain.general}" = tls // {
      locations."/" = {
        proxyPass = "http://${config.services.ntfy-sh.settings.listen-http}";
        proxyWebsockets = true;
      };
    };
    "atuin.${secrets.domain.general}" = tls // {
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString config.services.atuin.port}";
      };
    };
  };

  networking.hostName = "bravo";

  system.stateVersion = "25.11";
}
