{ self, inputs, ... }:

{
  flake.nixosConfigurations.charlie =
    let
      secrets = fromTOML (builtins.readFile ../../../secrets/secrets.toml);
    in
    inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit secrets; };
      modules = with self.nixosModules; [
        charlie
      ];
    };

  flake.nixosModules.charlie = { config, secrets, ... }: {
    imports =
      with self;
      with self.nixosModules;
      [
        diskoConfigurations.charlie

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

    deploy.tags = [
      "germany"
    ];

    deploy.ipv4-address = secrets.hosts.charlie.ipv4-address;

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

  flake.diskoConfigurations.charlie = {
    imports = with inputs; [
      disko.nixosModules.disko
    ];

    disko.devices = {
      disk = {
        one = {
          type = "disk";
          device = "/dev/sda";
          content = {
            type = "gpt";
            partitions = {
              boot = {
                size = "1M";
                type = "EF02";
              };
              ESP = {
                size = "256M";
                type = "EF00";
                content = {
                  type = "filesystem";
                  format = "vfat";
                  mountpoint = "/boot";
                  mountOptions = [
                    "umask=0077"
                  ];
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
                    type = "lvm_pv";
                    vg = "pool";
                  };
                };
              };
            };
          };
        };
      };
      lvm_vg = {
        pool = {
          type = "lvm_vg";
          lvs = {
            root = {
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = [
                  "-f"
                ];
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
                      swap.swapfile.size = "8G";
                    };
                  };
              };
            };
          };
        };
      };
    };
  };

  flake.nixosModules.charlie-sshKnownHosts = { config, secrets, ... }: {
    programs.ssh.knownHosts = rec {
      charlie = {
        extraHostNames = [
          "charlie.${config.networking.domain}"
          secrets.hosts.charlie.ipv4-address
          "10.2.1.3"
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
          "[10.2.1.3]:22022"
        ];
        publicKeyFile = ./keys/ssh_initrd_ed25519_key.pub;
      };
      "charlie-initrd/rsa" = {
        hostNames = [ "[charlie]:22022" ] ++ charlie-initrd.extraHostNames;
        publicKeyFile = ./keys/ssh_initrd_rsa_key.pub;
      };
    };
  };

  flake.nixosModules.charlie-cache = {
    nix.settings.trusted-public-keys = [
      "charlie:DqW45gRQrBrz0LbfDnWLbaqzgqnHMG+HGv9TUUyABf4="
    ];
  };
}
