{ self, inputs, ... }:

{
  flake.nixosConfigurations.shodan =
    let
      secrets = fromTOML (builtins.readFile ../../../secrets/secrets.toml);
    in
    inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit secrets; };
      modules = with self.nixosModules; [
        hosts-shodan
      ];
    };

  flake.nixosModules.hosts-shodan =
    {
      config,
      lib,
      secrets,
      ...
    }:
    {
      imports =
        with self;
        with self.nixosModules;
        [
          diskoConfigurations.shodan

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

      services.sabnzbd.settings.misc.host_whitelist =
        "sabnzbd.${secrets.domain.general},localhost,127.0.0.1,${secrets.hosts.shodan.tailscale-address}";

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
              proxyPass = "http://127.0.0.1:${toString sabnzbd.settings.misc.port}";
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

  flake.diskoConfigurations.shodan = {
    imports = with inputs; [
      disko.nixosModules.disko
    ];

    disko.devices = {
      disk = {
        nvme = {
          type = "disk";
          device = "/dev/nvme0n1";
          content = {
            type = "gpt";
            partitions = {
              boot = {
                size = "1M";
                type = "EF02";
              };
              ESP = {
                size = "1G";
                type = "EF00";
                priority = 1;
                content = {
                  type = "filesystem";
                  format = "vfat";
                  mountpoint = "/boot";
                  mountOptions = [ "umask=0077" ];
                };
              };
              root = {
                size = "100%";
                content = {
                  type = "luks";
                  name = "cryptroot";
                  passwordFile = "/tmp/passwd";
                  settings.allowDiscards = true;
                  content = {
                    type = "btrfs";
                    extraArgs = [ "--force" ];
                    subvolumes =
                      let
                        mountOptions = [
                          "compress=zstd"
                          "noatime"
                        ];
                      in
                      {
                        "@rootfs" = {
                          inherit mountOptions;
                          mountpoint = "/";
                        };
                        "@nix" = {
                          inherit mountOptions;
                          mountpoint = "/nix";
                        };
                        "@persistent" = {
                          inherit mountOptions;
                          mountpoint = "/persistent";
                        };
                        "@swap" = {
                          mountpoint = "/var/lib/swap";
                          swap.swapfile.size = "64G";
                        };
                      };
                  };
                };
              };
            };
          };
        };
        one = {
          type = "disk";
          device = "/dev/sda";
          content = {
            type = "gpt";
            partitions = {
              data = {
                size = "100%";
                content = {
                  type = "luks";
                  name = "cryptdata1";
                  passwordFile = "/tmp/passwd";
                  settings.allowDiscards = true;
                };
              };
            };
          };
        };
        two = {
          type = "disk";
          device = "/dev/sdb";
          content = {
            type = "gpt";
            partitions = {
              data = {
                size = "100%";
                content = {
                  type = "luks";
                  name = "cryptdata2";
                  passwordFile = "/tmp/passwd";
                  settings.allowDiscards = true;
                  content = {
                    type = "btrfs";
                    extraArgs = [
                      "--force"
                      "--data=single"
                      "--metadata=raid1"
                      "/dev/mapper/cryptdata1"
                    ];
                    subvolumes = {
                      "@storage" = {
                        mountpoint = "/storage";
                        mountOptions = [
                          "compress=zstd"
                          "noatime"
                        ];
                      };
                    };
                  };
                };
              };
            };
          };
        };
      };
    };
  };

  flake.nixosModules.hosts-shodan-sshKnownHosts = { config, secrets, ... }: {
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
