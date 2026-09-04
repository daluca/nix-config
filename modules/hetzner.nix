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

    colmena.tags = [
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
}
