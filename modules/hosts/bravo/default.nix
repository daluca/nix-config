{ self, inputs, ... }:

{
  flake.nixosConfigurations.bravo =
    let
      secrets = fromTOML (builtins.readFile ../../../secrets/secrets.toml);
    in
    inputs.nixos-raspberrypi.lib.nixosSystem {
      system = "aarch64-linux";
      specialArgs = { inherit secrets; };
      modules = with self.nixosModules; [
        bravo
      ];
    };

  flake.nixosModules.bravo =
    {
      config,
      pkgs,
      secrets,
      ...
    }:
    {
      imports =
        with self;
        with self.nixosModules;
        [
          diskoConfigurations.bravo

          hetzner-cloud-arm

          users-remotebuild

          remote-unlocking-dhcp
          impermanence-grub
          nginx
          ntfy
          atuin
          miniflux
        ];

      sops.defaultSopsFile = ./bravo.sops.yaml;

      environment.etc."ssh/ssh_initrd_ed25519_key.pub".source = ./keys/ssh_initrd_ed25519_key.pub;

      environment.etc."ssh/ssh_initrd_rsa_key.pub".source = ./keys/ssh_initrd_rsa_key.pub;

      deploy.tags = [
        "germany"
      ];

      deploy.ipv4-address = secrets.hosts.bravo.ipv4-address;

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
        in
        with config.services;
        {
          "ntfy.${secrets.domain.general}" = tls // {
            locations."/" = {
              proxyPass = "http://${ntfy-sh.settings.listen-http}/";
              proxyWebsockets = true;
            };
          };
          "atuin.${secrets.domain.general}" = tls // {
            locations."/" = {
              proxyPass = "http://127.0.0.1:${toString atuin.port}/";
            };
          };
          "miniflux.${secrets.domain.general}" = tls // {
            locations."/" = {
              proxyPass = "http://${miniflux.config.LISTEN_ADDR}/";
            };
          };
          "nextflux.${secrets.domain.general}" = tls // {
            locations."/" = {
              root = "${pkgs.nextflux}/share/html";
              tryFiles = "$uri $uri/ index.html =403";
            };
          };
        };

      networking.hostName = "bravo";

      system.stateVersion = "26.05";
    };

  flake.diskoConfigurations.bravo = {
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
                      swap.swapfile.size = "4G";
                    };
                  };
              };
            };
          };
        };
      };
    };
  };

  flake.nixosModules.bravo-sshKnownHosts = { config, secrets, ... }: {
    programs.ssh.knownHosts = rec {
      bravo = {
        extraHostNames = [
          "bravo.${config.networking.domain}"
          secrets.hosts.bravo.ipv4-address
          "10.2.1.2"
        ];
        publicKeyFile = ./keys/ssh_host_ed25519_key.pub;
      };
      "bravo/rsa" = {
        hostNames = [ "bravo" ] ++ bravo.extraHostNames;
        publicKeyFile = ./keys/ssh_host_rsa_key.pub;
      };
      bravo-initrd = {
        hostNames = [ "[bravo]:22022" ] ++ bravo-initrd.extraHostNames;
        extraHostNames = [
          "[bravo.${config.networking.domain}]:22022"
          "[${secrets.hosts.bravo.ipv4-address}]:22022"
          "[10.2.1.2]:22022"
        ];
        publicKeyFile = ./keys/ssh_initrd_ed25519_key.pub;
      };
      "bravo-initrd/rsa" = {
        hostNames = [ "[bravo]:22022" ] ++ bravo-initrd.extraHostNames;
        publicKeyFile = ./keys/ssh_initrd_rsa_key.pub;
      };
    };
  };

  flake.nixosModules.bravo-cache = {
    nix.settings.trusted-public-keys = [
      "bravo:2zk2IqImbGCABS9Ly1akZZ8P9xq8MkzCXFmdAlH23h0="
    ];
  };
}
