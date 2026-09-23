{ self, inputs, ... }:

{
  flake.nixosConfigurations.alfa =
    let
      secrets =
        fromTOML (builtins.readFile ../../../secrets/secrets.toml)
        // fromTOML (builtins.readFile ./secrets.toml);
    in
    inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit secrets; };
      modules = with self.nixosModules; [
        hosts-alfa
      ];
    };

  flake.nixosModules.hosts-alfa = { secrets, ... }: {
    imports =
      with self;
      with self.nixosModules;
      [
        diskoConfigurations.alfa

        hetzner-cloud-x86

        users-remotebuild

        remote-unlocking-dhcp
        impermanence-grub
        nginx
        tailscale-server
        atticd
      ];

    sops.defaultSopsFile = ./alfa.sops.yaml;

    environment.etc."ssh/ssh_initrd_ed25519_key.pub".source = ./keys/ssh_initrd_ed25519_key.pub;

    environment.etc."ssh/ssh_initrd_rsa_key.pub".source = ./keys/ssh_initrd_rsa_key.pub;

    deploy.tags = [
      "germany"
    ];

    deploy.ipv4-address = secrets.hosts.alfa.ipv4-address;

    networking.localCommands = /* bash */ ''
      ip rule add to 10.2.1.0/24 priority 2500 lookup main || true
    '';

    services.tailscale.extraUpFlags = [
      "--advertise-routes=10.2.1.0/24"
    ];

    services.nginx.virtualHosts = {
      "attic.${secrets.domain.general}" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:8080";
        };
        extraConfig = /* nginx */ ''
          client_max_body_size 1G;
        '';
      };
    };

    networking.hostName = "alfa";

    system.stateVersion = "26.05";
  };

  flake.diskoConfigurations.alfa = {
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

  flake.nixosModules.hosts-alfa-sshKnownHosts = { config, secrets, ... }: {
    programs.ssh.knownHosts = rec {
      alfa = {
        extraHostNames = [
          "alfa.${config.networking.domain}"
          secrets.hosts.alfa.ipv4-address
          "10.2.1.1"
        ];
        publicKeyFile = ./keys/ssh_host_ed25519_key.pub;
      };
      "alfa/rsa" = {
        hostNames = [ "alfa" ] ++ alfa.extraHostNames;
        publicKeyFile = ./keys/ssh_host_rsa_key.pub;
      };
      alfa-initrd = {
        hostNames = [ "[alfa]:22022" ] ++ alfa-initrd.extraHostNames;
        extraHostNames = [
          "[alfa.${config.networking.domain}]:22022"
          "[${secrets.hosts.alfa.ipv4-address}]:22022"
          "[10.2.1.1]:22022"
        ];
        publicKeyFile = ./keys/ssh_initrd_ed25519_key.pub;
      };
      "alfa-initrd/rsa" = {
        hostNames = [ "[alfa]:22022" ] ++ alfa-initrd.extraHostNames;
        publicKeyFile = ./keys/ssh_initrd_rsa_key.pub;
      };
    };
  };

  flake.nixosModules.hosts-alfa-cache = {
    nix.settings.trusted-public-keys = [
      "alfa:02xNXVHoJQjRic5IZk/NDNJDIhlRq+tLq+e21kVtUTs="
    ];
  };
}
