{ self, inputs, ... }:

{
  flake.nixosConfigurations.stormwind = inputs.nixpkgs.lib.nixosSystem {
    system = "aarch64-linux";
    modules = with self.nixosModules; [
      hosts-stormwind
    ];
  };

  flake.nixosModules.hosts-stormwind = { ... }: {
    imports = with self.nixosModules; [
      server
      raspberry-pi-4

      adguardhome-netherlands
      tailscale-server
    ];

    sops.defaultSopsFile = ./stormwind.sops.yaml;

    colmena.tags = [
      "the-netherlands"
    ];

    services.getty.autologinUser = "daluca";

    networking.localCommands = /* bash */ ''
      ip rule add to 10.1.0.0/16 priority 2500 lookup main || true
    '';

    services.tailscale.extraUpFlags = [
      "--advertise-routes=10.1.0.0/16"
      "--hostname=the-netherlands"
    ];

    networking.hostName = "stormwind";

    system.stateVersion = "26.05";
  };

  flake.nixosModules.hosts-stormwind-sshKnownHosts = { config, ... }: {
    programs.ssh.knownHosts = rec {
      stormwind = {
        extraHostNames = [
          "stormwind.${config.networking.domain}"
          "10.1.1.10"
        ];
        publicKeyFile = ./keys/ssh_host_ed25519_key.pub;
      };
      "stormwind/rsa" = {
        hostNames = [ "stormwind" ] ++ stormwind.extraHostNames;
        publicKeyFile = ./keys/ssh_host_rsa_key.pub;
      };
    };
  };
}
