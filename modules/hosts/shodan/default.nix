{ self, inputs, ... }:
let
  secrets = fromTOML (builtins.readFile ../../../secrets/secrets.toml);
in
{
  flake.nixosConfigurations.shodan = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = with self.nixosModules; [
      hosts-shodan
    ];
  };

  flake.nixosModules.hosts-shodan = { config, lib, ... }: {
    imports = with self.nixosModules; [
      hosts-shodan-disko

      hetzner-online-intel

      users-starr

      nginx
      tailscale-server
      impermanence-grub
      remote-unlocking
      grub

      jellyfin
      seerr
      sonarr
      radarr
      prowlarr
      configarr
      sabnzbd
      qbittorrent
    ];

    sops.defaultSopsFile = ./shodan.sops.yaml;

    environment.etc."ssh/ssh_initrd_ed25519_key.pub".source = ./keys/ssh_initrd_ed25519_key.pub;

    environment.etc."ssh/ssh_initrd_rsa_key.pub".source = ./keys/ssh_initrd_rsa_key.pub;

    deploy.tags = [
      "germany"
    ];

    deploy.ipv4-address = secrets.hosts.shodan.tailscale-address;

    boot.loader.grub.default = lib.mkForce "0";

    hardware.graphics.enable = true;

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
        "jellyfin.${secrets.domain.general}" = tls // {
          extraConfig = /* nginx */ ''
            client_max_body_size 20M;
            add_header X-Content-Type-Options "nosniff";
            add_header Permissions-Policy "accelerometer=(), ambient-light-sensor=(), battery=(), bluetooth=(), camera=(), clipboard-read=(), display-capture=(), document-domain=(), encrypted-media=(), gamepad=(), geolocation=(), gyroscope=(), hid=(), idle-detection=(), interest-cohort=(), keyboard-map=(), local-fonts=(), magnetometer=(), microphone=(), payment=(), publickey-credentials-get=(), serial=(), sync-xhr=(), usb=(), xr-spatial-tracking=()" always;
            add_header Content-Security-Policy "default-src https: data: blob: ; img-src 'self' https://* ; style-src 'self' 'unsafe-inline'; script-src 'self' 'unsafe-inline' https://www.gstatic.com https://www.youtube.com blob:; worker-src 'self' blob:; connect-src 'self'; object-src 'none'; frame-ancestors 'self'; font-src 'self'";
          '';
          locations =
            let
              jellyfin = "http://127.0.0.1:8096";
            in
            {
              "/" = {
                proxyPass = jellyfin;
                extraConfig = /* nginx */ ''
                  proxy_buffering off;
                '';
              };
              "/socket" = {
                proxyPass = jellyfin;
                proxyWebsockets = true;
              };
            };
        };

        "request.${secrets.domain.general}" = tls // {
          locations."/" = {
            proxyPass = "http://127.0.0.1:5055";
          };
        };

        "requests.${secrets.domain.general}" = tls // {
          locations."/".return = ''
            301 $scheme://request.${secrets.domain.general}$request_uri
          '';
        };

        "sonarr.${secrets.domain.general}" = tls // {
          locations."/" = {
            proxyPass = "http://127.0.0.1:${toString sonarr.settings.server.port}";
          };
        };

        "radarr.${secrets.domain.general}" = tls // {
          locations."/" = {
            proxyPass = "http://127.0.0.1:${toString radarr.settings.server.port}";
          };
        };

        "prowlarr.${secrets.domain.general}" = tls // {
          locations."/" = {
            proxyPass = "http://127.0.0.1:${toString prowlarr.settings.server.port}";
          };
        };

        "sabnzbd.${secrets.domain.general}" = tls // {
          locations."/" = {
            proxyPass = "http://127.0.0.1:8080";
          };
        };

        "qbittorrent.${secrets.domain.general}" = tls // {
          locations."/" = {
            proxyPass = "http://127.0.0.1:${toString qbittorrent.webuiPort}";
          };
        };
      };

    networking.hostName = "shodan";

    systemd.network.networks."10-uplink".networkConfig.Address = secrets.hosts.shodan.ipv6-address;

    host.network.interface = "enp0s31f6";

    system.stateVersion = "26.05";
  };

  flake.nixosModules.hosts-shodan-sshKnownHosts = { config, ... }: {
    programs.ssh.knownHosts = rec {
      shodan = {
        extraHostNames = with secrets.hosts.shodan; [
          "shodan.${config.networking.domain}"
          ipv4-address
          tailscale-address
        ];
        publicKeyFile = ./keys/ssh_host_ed25519_key.pub;
      };
      "shodan/rsa" = {
        hostNames = [ "shodan" ] ++ shodan.extraHostNames;
        publicKeyFile = ./keys/ssh_host_rsa_key.pub;
      };
      shodan-initrd = {
        hostNames = [ "[shodan]:22022" ] ++ shodan-initrd.extraHostNames;
        extraHostNames = [
          "[shodan.${config.networking.domain}]:22022"
          "[${secrets.hosts.shodan.ipv4-address}]:22022"
        ];
        publicKeyFile = ./keys/ssh_initrd_ed25519_key.pub;
      };
      "shodan-initrd/rsa" = {
        hostNames = [ "[shodan]:22022" ] ++ shodan-initrd.extraHostNames;
        publicKeyFile = ./keys/ssh_initrd_rsa_key.pub;
      };
    };
  };

  flake.nixosModules.hosts-shodan-cache = {
    nix.settings.trusted-public-keys = [
      "shodan:mMDpBB3EH23WqUms4rvrNPy6Ro7tSOGb33IYcxkeQyk="
    ];
  };
}
