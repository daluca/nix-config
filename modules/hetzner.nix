{ self, inputs, ... }:

{
  flake.nixosModules.hetzner = { config, lib, ... }: {
    imports =
      with inputs;
      with self.nixosModules;
      [
        srvos.nixosModules.server

        users-root
        server
      ];

    deploy.tags = [
      "hetzner"
      "vps"
    ];

    system.preSwitchChecks.detectHostnameChange = lib.mkForce /* bash */ ''
      detectHostnameChange() {
        local actual
        actual=$(< /proc/sys/kernel/hostname)

        # Ignore if the system is getting installed
        # https://github.com/nix-community/nixos-images/blob/2fc023e024c0a5e8e98ae94363dbf2962da10886/nix/installer.nix#L12-L13
        if [[ ! -e /run/booted-system || "$actual" == "nixos-installer" ]]; then
          return
        fi

        desired="${config.networking.hostName}"

        if [[ "$actual" = "$desired" ]]; then
          return
        fi

        # Useful for automation
        if [[ "''${EXPECTED_HOSTNAME:-}" = "$desired" ]]; then
          return
        fi

        log() {
          echo "$*" >&2
        }

        log "WARNING: machine hostname change detected from '$actual' to '$desired'"
        log
        log "Are you deploying on the right host?"
        log
        log "Type YES to continue:"
        read -r reply
        if [[ $reply != YES ]]; then
          echo "aborting"
          exit 1
        fi
      }
      detectHostnameChange
    '';

    documentation.nixos.enable = false;

    systemd.enableEmergencyMode = false;

    boot.loader.grub.entries.bios = lib.mkForce false;
  };

  flake.nixosModules.hetzner-cloud = { lib, ... }: {
    imports = with self.nixosModules; [
      hetzner
    ];

    boot.growPartition = lib.mkImageMediaOverride false;

    services.cloud-init.enable = false;

    networking.useDHCP = lib.mkForce true;

    host.network.interface = "enp1s0";
  };

  flake.nixosModules.hetzner-cloud-x86 = {
    imports =
      with inputs;
      with self.nixosModules;
      [
        srvos.nixosModules.hardware-hetzner-cloud

        hetzner-cloud
      ];
  };

  flake.nixosModules.hetzner-cloud-arm = {
    imports =
      with inputs;
      with self.nixosModules;
      [
        srvos.nixosModules.hardware-hetzner-cloud-arm

        hetzner-cloud
      ];
  };

  flake.nixosModules.hetzner-online = { config, lib, ... }: {
    imports = with self.nixosModules; [
      hetzner
    ];

    boot.loader.efi.canTouchEfiVariables = lib.mkForce false;

    boot.loader.grub.efiSupport = lib.mkForce false;

    boot.initrd.systemd.network.networks."10-uplink" = config.systemd.network.networks."10-uplink";

    boot.initrd.availableKernelModules = [
      "e1000e"
    ];
  };

  flake.nixosModules.hetzner-online-intel = {
    imports =
      with inputs;
      with self.nixosModules;
      [
        srvos.nixosModules.hardware-hetzner-online-intel

        hetzner-online
      ];
  };

  flake.diskoConfigurations.hetzner-cloud = {
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
                    type = "btrfs";
                    extraArgs = [
                      "--force"
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
    };
  };

  flake.homeModules.hetzner =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      home.packages = with pkgs; [
        hcloud
      ];

      sops.templates."hcloud-cli.toml" = {
        path = "${config.xdg.configHome}/hcloud/cli.toml";
        content = /* toml */ ''
          active_context = "default"

          [[contexts]]
          name = "default"
          token = "${config.sops.placeholder."nix-config/default/HCLOUD_TOKEN"}"
        '';
      };

      sops.secrets."nix-config/default/HCLOUD_TOKEN" = {
        sopsFile = ../secrets/secrets.sops.yaml;
      };

      programs.zsh.initContent = /* zsh */ ''
        eval "$( ${lib.getExe pkgs.hcloud} completion zsh )"
      '';
    };
}
