{ config, lib, secrets, inputs, ... }:

{
  imports = with inputs; [
    disko.nixosModules.disko
  ] ++ [
    ./..
    ./disko.nix
  ] ++ map (m: lib.custom.relativeToRoot m) [
    "images/hetzner/cloud/arm"
  ] ++ map (m: lib.custom.relativeToUsers m) [
    "remotebuild"
  ] ++ map (m: lib.custom.relativeToNixosModules m) [
    "impermanence"
    "nginx"
    "ntfy-sh"
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
  };

  networking.hostName = "bravo";

  boot = {
    kernelParams = [ "ip=dhcp" ];
    initrd = {
      availableKernelModules = [ "virtio-pci" ];
      network = {
        enable = true;
        ssh = {
          enable = true;
          port = 22;
          authorizedKeyFiles = [
            (lib.custom.relativeToUsers "daluca/keys/id_ed25519.pub")
          ];
          hostKeys = [
            "/persistent/system/etc/ssh/ssh_host_ed25519_key"
            "/persistent/system/etc/ssh/ssh_host_rsa_key"
          ];
          shell = "/bin/cryptsetup-askpass";
        };
      };
    };
  };

  system.stateVersion = "25.05";
}
