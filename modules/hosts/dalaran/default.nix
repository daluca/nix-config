{ self, inputs, ... }:
let
  secrets = fromTOML (builtins.readFile ../../../secrets/secrets.toml);
in{
  flake.nixosConfigurations.dalaran = inputs.nixos-raspberrypi.lib.nixosSystem {
    system = "aarch64-linux";
    modules = with self.nixosModules; [
      hosts-dalaran
    ];
  };

  flake.nixosModules.hosts-dalaran = { config, ... }: {
    imports = with self.nixosModules; [
      hosts-dalaran-disko

      server
      raspberry-pi-5

      users-remotebuild

      nginx
      adguardhome-dalaran
      paperless
      redlib
      firefly-iii
      navidrome
      localContentShare
      gatus
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
      in
      with config.services;
      {
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

        "share.${secrets.domain.general}" = tls // {
          locations."/" = {
            proxyPass = "http://127.0.0.1:${toString local-content-share.port}";
            extraConfig = /* nginx */ ''
              client_max_body_size 5G;
              proxy_request_buffering off;
              proxy_buffering off;
              proxy_read_timeout 3600s;
              proxy_send_timeout 3600s;
              proxy_connect_timeout 3600s;
            '';
          };
        };

        "gatus.${secrets.domain.general}" = tls // {
          locations."/" = {
            proxyPass = "http://127.0.0.1:${toString gatus.settings.web.port}";
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

        "unifi.${secrets.domain.general}" = tls // {
          locations."/" = {
            proxyPass = "https://10.1.1.1:443";
          };
          locations."/api/ws/" = {
            proxyPass = "https://10.1.1.1:443";
            proxyWebsockets = true;
            extraConfig = /* nginx */ ''
              proxy_ssl_verify off;
            '';
          };
          locations."/proxy/network/ws/" = {
            proxyPass = "https://10.1.1.1:443";
            proxyWebsockets = true;
            extraConfig = /* nginx */ ''
              proxy_ssl_verify off;
            '';
          };
        };

        ${firefly-iii.virtualHost} = tls;

        ${firefly-iii-data-importer.virtualHost} = tls;
      };

    services.paperless.settings = {
      PAPERLESS_URL = "https://paperless.${secrets.domain.general}";
    };

    services.firefly-iii.virtualHost = "firefly.${secrets.domain.general}";

    services.firefly-iii-data-importer.virtualHost = "firefly-importer.${secrets.domain.general}";

    services.firefly-iii-data-importer.settings = {
      VANITY_URL = "https://firefly.${secrets.domain.general}";
      FIREFLY_III_URL = "https://firefly.${secrets.domain.general}";
      FIREFLY_III_CLIENT_ID = "019f5ca9-1f9a-71a5-a0a1-9733ffb75a50";
    };

    services.redlib.settings = {
      REDLIB_FULL_URL = "redlib.${secrets.domain.general}";
    };

    sops.defaultSopsFile = ./dalaran.sops.yaml;

    colmena.tags = [
      "the-netherlands"
    ];

    networking.hostName = "dalaran";

    hardware.raspberry-pi.config = {
      all.base-dt-params = {
        pciex1_gen = {
          enable = true;
          value = 3;
        };
      };
    };

    system.stateVersion = "25.11";
  };

  flake.nixosModules.hosts-dalaran-sshKnownHosts = { config, ... }: {
    programs.ssh.knownHosts = rec {
      dalaran = {
        extraHostNames = [
          "dalaran.${config.networking.domain}"
          "10.1.1.11"
        ];
        publicKeyFile = ./keys/ssh_host_ed25519_key.pub;
      };
      "dalaran/rsa" = {
        hostNames = [ "dalaran" ] ++ dalaran.extraHostNames;
        publicKeyFile = ./keys/ssh_host_rsa_key.pub;
      };
    };
  };

  flake.nixosModules.hosts-dalaran-cache = {
    nix.settings.trusted-public-keys = [
      "dalaran:p7uH92Bwi9P2dzRMqGmmn/yB4BrCP42QvxjkiBibMuk="
    ];
  };
}
