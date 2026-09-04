{ self, inputs, ... }:
let
  secrets = fromTOML (builtins.readFile ../../../secrets/secrets.toml);
in
{
  flake.nixosConfigurations.charlie = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = with self.nixosModules; [
      hosts-charlie
    ];
  };

  flake.nixosModules.hosts-charlie = { config, ... }: {
    imports = with self.nixosModules; [
      hosts-charlie-disko

      hetzner-cloud-x86

      users-remotebuild

      nginx
      hister
      pocket-id
      remote-unlocking-dhcp
      impermanence-grub
    ];

    sops.defaultSopsFile = ./charlie.sops.yaml;

    environment.etc."ssh/ssh_initrd_ed25519_key.pub".source = ./keys/ssh_initrd_ed25519_key.pub;

    environment.etc."ssh/ssh_initrd_rsa_key.pub".source = ./keys/ssh_initrd_rsa_key.pub;

    colmena.tags = [
      "germany"
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
  };

  flake.nixosModules.hosts-charlie-sshKnownHosts = { config, ... }: {
    programs.ssh.knownHosts = rec {
      charlie = {
        extraHostNames = [
          "charlie.${config.networking.domain}"
          secrets.hosts.charlie.ipv4-address
        ];
        publicKeyFile = ./keys/ssh_host_ed25519_key.pub;
      };
      "charlie/rsa" = {
        hostNames = [ "charlie" ] ++ charlie.extraHostNames;
        publicKeyFile = ./keys/ssh_host_rsa_key.pub;
      };
      charlie-initrd = {
        hostNames = [ "[charlie]:22022" ] ++ charlie-initrd.extraHostNames;
        extraHostNames = [
          "[charlie.${config.networking.domain}]:22022"
          "[${secrets.hosts.charlie.ipv4-address}]:22022"
        ];
        publicKeyFile = ./keys/ssh_initrd_ed25519_key.pub;
      };
      "charlie-initrd/rsa" = {
        hostNames = [ "[charlie]:22022" ] ++ charlie-initrd.extraHostNames;
        publicKeyFile = ./keys/ssh_initrd_rsa_key.pub;
      };
    };
  };

  flake.nixosModules.hosts-charlie-cache = {
    nix.settings.trusted-public-keys = [
      "charlie:DqW45gRQrBrz0LbfDnWLbaqzgqnHMG+HGv9TUUyABf4="
    ];
  };
}
