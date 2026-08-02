{
  config,
  lib,
  secrets,
  outputs,
  ...
}:

{
  imports =
    with outputs.nixosModules;
    [
      ./..
      ./disko.nix

      hetzner-cloud-x86
    ]
    ++ map (m: lib.custom.relativeToUsers m) [
      "remotebuild"
    ]
    ++ map (m: lib.custom.relativeToNixosModules m) [
      "impermanence/grub"
      "remote-unlocking/dhcp"
      "nginx"
      "pocket-id"
      "hister"
    ];

  services.hister.settings = {
    server = {
      base_url = "https://hister.${secrets.domain.general}";
    };
  };

  services.pocket-id.settings = {
    APP_URL = "https://id.${secrets.domain.general}";
    TRUSTED_PLATFORM = "CF-Connecting-IP";
  };

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
    in
    with config.services;
    {
      "id.${secrets.domain.general}" = tls // {
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString pocket-id.settings.PORT}";
          extraConfig = /* nginx */ ''
            proxy_busy_buffers_size   512k;
            proxy_buffers   4 512k;
            proxy_buffer_size   256k;
          '';
        };
      };
      "hister.${secrets.domain.general}" = tls // {
        http2 = true;
        http3 = true;
        quic = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString hister.port}";
          proxyWebsockets = true;
          extraConfig = /* nginx */ ''
            gzip off;
            proxy_read_timeout 86400;
          '';
        };
        extraConfig = /* nginx */ ''
          add_header Alt-Svc 'h3=":443"; ma=86400; persist=1';
        '';
      };
    };

  networking.hostName = "charlie";

  system.stateVersion = "26.05";
}
