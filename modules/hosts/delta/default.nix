{ self, inputs, ... }:

{
  flake.nixosConfigurations.delta =
    let
      secrets = fromTOML (builtins.readFile ../../../secrets/secrets.toml);
    in
    inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit secrets; };
      modules = with self.nixosModules; [
        delta
      ];
    };

  flake.nixosModules.delta = { secrets, ... }: {
    imports =
      with self;
      with self.nixosModules;
      [
        hetzner-cloud-x86
        diskoConfigurations.hetzner-cloud
        remote-unlocking-dhcp
        impermanence-grub
        tailscale-server
        nginx
      ];

    security.acme.certs.${secrets.domain.general}.domain = "*.${secrets.domain.general}";

    networking.localCommands = /* bash */ ''
      ip rule add to 10.2.1.0/24 priority 2500 lookup main || true
    '';

    services.tailscale.extraUpFlags = [
      "--advertise-routes=10.2.1.0/24"
    ];

    sops.defaultSopsFile = ./delta.sops.yaml;

    environment.etc."ssh/ssh_initrd_ed25519_key.pub".source = ./keys/ssh_initrd_ed25519_key.pub;

    environment.etc."ssh/ssh_initrd_rsa_key.pub".source = ./keys/ssh_initrd_rsa_key.pub;

    deploy.tags = [
      "germany"
    ];

    deploy.ipv4-address = "10.2.1.4";

    networking.hostName = "delta";

    system.stateVersion = "26.05";
  };

  flake.nixosModules.ssh = { config, secrets, ... }: {
    programs.ssh.knownHosts = rec {
      delta = {
        extraHostNames = [
          "delta.${config.networking.domain}"
          secrets.hosts.delta.ipv4-address
          "10.2.1.4"
        ];
        publicKeyFile = ./keys/ssh_host_ed25519_key.pub;
      };
      "delta/rsa" = {
        hostNames = [ "delta" ] ++ delta.extraHostNames;
        publicKeyFile = ./keys/ssh_host_rsa_key.pub;
      };
      delta-initrd = {
        hostNames = [ "[delta]:22022" ] ++ delta-initrd.extraHostNames;
        extraHostNames = [
          "[delta.${config.networking.domain}]:22022"
          "[${secrets.hosts.delta.ipv4-address}]:22022"
          "[10.2.1.4]:22022"
        ];
        publicKeyFile = ./keys/ssh_initrd_ed25519_key.pub;
      };
      "delta-initrd/rsa" = {
        hostNames = [ "[delta]:22022" ] ++ delta-initrd.extraHostNames;
        publicKeyFile = ./keys/ssh_initrd_rsa_key.pub;
      };
    };
  };

  flake.nixosModules.nix-cache = {
    nix.settings.trusted-public-keys = [
      "delta:x5bUayVX+r2WLqC8VjCvdb9seyybxKVih82F8vVEfB4="
    ];
  };
}
