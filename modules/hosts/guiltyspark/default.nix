{ self, inputs, ... }:
let
  secrets =
    fromTOML (builtins.readFile ../../../secrets/secrets.toml)
    // fromTOML (builtins.readFile ./secrets.toml);
in
{
  flake.nixosConfigurations.guiltyspark = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = { inherit secrets; };
    modules = with self.nixosModules; [
      hosts-guiltyspark
    ];
  };

  flake.nixosModules.hosts-guiltyspark = { config, secrets, ... }: {
    imports =
      with inputs;
      with self;
      with self.nixosModules;
      [
        nixos-hardware.nixosModules.common-cpu-intel

        diskoConfigurations.guiltyspark

        server

        users-starr
        users-remotebuild

        nginx
        grub
        tailscale-server
        jellyfin
        seerr
        sonarr
        radarr
        prowlarr
        sabnzbd
        cockpit
        plex
        jellyplex-watched
        tunarr
      ];

    sops.defaultSopsFile = ./guiltyspark.sops.yaml;

    deploy.tags = [
      "new-zealand"
    ];

    deploy.ipv4-address = secrets.hosts.guiltyspark.tailscale-address;

    # TODO: Remove in 26.11 as it will be the new default
    boot.zfs.forceImportRoot = false;

    services.sabnzbd.settings.misc.host_whitelist =
      "sabnzbd.${secrets.parents.domain},localhost,127.0.0.1,${secrets.hosts.guiltyspark.tailscale-address}";

    networking = {
      hostName = "guiltyspark";
      hostId = "5c9bd4a2";
    };

    host.network.interface = "eno1";

    services.tailscale.extraUpFlags = [
      "--advertise-routes=192.168.10.0/24"
    ];

    networking.localCommands = /* bash */ ''
      ip rule add to 192.168.10.0/24 priority 2500 lookup main || true
    '';

    security.acme.certs.${secrets.parents.domain}.domain = "*.${secrets.parents.domain}";

    services.nginx.virtualHosts =
      let
        cert = config.security.acme.certs.${secrets.parents.domain};
        sslCertificate = "${cert.directory}/fullchain.pem";
        sslCertificateKey = "${cert.directory}/key.pem";
        sslTrustedCertificate = "${cert.directory}/chain.pem";
        tls = {
          inherit sslCertificate sslCertificateKey sslTrustedCertificate;
          forceSSL = true;
        };
      in
      {
        "jellyfin.${secrets.parents.domain}" = tls // {
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

        "plex.${secrets.parents.domain}" = tls // {
          locations."/" = {
            proxyPass = "http://127.0.0.1:32400";
          };
        };

        "request.${secrets.parents.domain}" = tls // {
          locations."/" = {
            proxyPass = "http://127.0.0.1:5055";
          };
        };

        "requests.${secrets.parents.domain}" = tls // {
          locations."/".return = ''
            301 $scheme://request.${secrets.parents.domain}$request_uri
          '';
        };

        "sonarr.${secrets.parents.domain}" = tls // {
          locations."/" = {
            proxyPass = "http://127.0.0.1:8989";
          };
        };

        "radarr.${secrets.parents.domain}" = tls // {
          locations."/" = {
            proxyPass = "http://127.0.0.1:7878";
          };
        };

        "prowlarr.${secrets.parents.domain}" = tls // {
          locations."/" = {
            proxyPass = "http://127.0.0.1:9696";
          };
        };

        "sabnzbd.${secrets.parents.domain}" = tls // {
          locations."/" = {
            proxyPass = "http://127.0.0.1:8080";
          };
        };

        "qbittorrent.${secrets.parents.domain}" = tls // {
          locations."/" = {
            proxyPass = "http://127.0.0.1:${toString config.services.qbittorrent.webuiPort}";
          };
        };

        "tunarr.${secrets.parents.domain}" = tls // {
          locations."/" = {
            proxyPass = "http://127.0.0.1:${toString config.services.tunarr.port}";
          };
        };
      };

    services.cloudflare-dyndns = {
      enable = true;
      proxied = true;
      apiTokenFile = config.sops.secrets."cloudflare/api-token".path;
      domains = [
        secrets.parents.domain
      ];
    };

    services.jellyplex-watched = {
      mappings.users = secrets.jellyplex-watched.users;
      plex.tokens = [ secrets.plex.token ];
      jellyfin.tokens = [ secrets.jellyfin.token ];
    };

    system.stateVersion = "26.05";
  };

  flake.diskoConfigurations.guiltyspark = {
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
              ESP = {
                size = "1G";
                type = "EF00";
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
                  type = "btrfs";
                  extraArgs = [ "-f" ];
                  subvolumes = {
                    "/rootfs" = {
                      mountpoint = "/";
                      mountOptions = [
                        "compress=zstd"
                        "noatime"
                      ];
                    };
                    "/home" = {
                      mountpoint = "/home";
                      mountOptions = [
                        "compress=zstd"
                        "noatime"
                      ];
                    };
                    "/nix" = {
                      mountpoint = "/nix";
                      mountOptions = [
                        "compress=zstd"
                        "noatime"
                      ];
                    };
                    "/swap" = {
                      mountpoint = "/swap";
                      swap.swapfile.size = "16G";
                    };
                  };
                  mountpoint = "/";
                  mountOptions = [
                    "compress=zstd"
                    "noatime"
                  ];
                };
              };
            };
          };
        };
        data0 = {
          type = "disk";
          device = "/dev/sda";
          content = {
            type = "gpt";
            partitions = {
              zfs = {
                size = "100%";
                content = {
                  type = "zfs";
                  pool = "tank";
                };
              };
            };
          };
        };
        data1 = {
          type = "disk";
          device = "/dev/sdb";
          content = {
            type = "gpt";
            partitions = {
              zfs = {
                size = "100%";
                content = {
                  type = "zfs";
                  pool = "tank";
                };
              };
            };
          };
        };
      };
      zpool = {
        tank = {
          type = "zpool";
          mode = "mirror";

          rootFsOptions = {
            compression = "zstd";
            atime = "off";
            mountpoint = "none";
            "com.sun:auto-snapshot" = "false";
          };

          postCreateHook = /* bash */ ''
            zfs snapshot tank@blank
          '';

          datasets = {
            "storage" = {
              type = "zfs_fs";
              options.mountpoint = "legacy";
              mountpoint = "/storage";
            };
          };
        };
      };
    };
  };

  flake.nixosModules.hosts-guiltyspark-sshKnownHosts = { config, ... }: {
    programs.ssh.knownHosts = rec {
      guiltyspark = {
        extraHostNames = [
          "guiltyspark.${config.networking.domain}"
          "192.168.10.20"
          "100.64.0.10"
        ];
        publicKeyFile = ./keys/ssh_host_ed25519_key.pub;
      };
      "guiltyspark/rsa" = {
        hostNames = [ "guiltyspark" ] ++ guiltyspark.extraHostNames;
        publicKeyFile = ./keys/ssh_host_rsa_key.pub;
      };
    };
  };

  flake.nixosModules.hosts-guiltyspark-cache = {
    nix.settings.trusted-public-keys = [
      "guiltyspark:V+aeGAYOSpIRyGv3qK0EURs8mOc4ovS/NH3g3XhCGKQ="
    ];
  };
}
