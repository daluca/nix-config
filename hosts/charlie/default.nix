{ config, lib, secrets, outputs, ... }:

{
  imports = with outputs.nixosModules; [
    ./..
    ./disko.nix

    hetzner-cloud-x86
  ] ++ map (m: lib.custom.relativeToUsers m) [
    "remotebuild"
  ] ++ map (m: lib.custom.relativeToNixosModules m) [
    "impermanence/grub"
    "remote-unlocking/dhcp"
    "nginx"
    "rustfs"
  ];

  security.acme.certs.${secrets.domain.general}.domain = "*.${secrets.domain.general}";

  services.nginx.upstreams = {
    rustfs = {
      servers."127.0.0.1:9000" = { };
      extraConfig = /* nginx */ ''
        least_conn;
      '';
    };
    rustfs-console = {
      servers."127.0.0.1:9001" = { };
      extraConfig = /* nginx */ ''
        least_conn;
      '';
    };
  };

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
    "rustfs.${secrets.domain.general}" = tls // {
      locations."/" = {
        proxyPass = "http://rustfs-console";
      };
      locations."/api" = {
        proxyPass = "http://rustfs";
      };
      extraConfig = /* nginx */ ''
        ignore_invalid_headers off;
        client_max_body_size 0;
        proxy_buffering off;
        proxy_request_buffering off;
      '';
    };
  };

  networking.hostName = "charlie";

  system.stateVersion = "25.11";
}
