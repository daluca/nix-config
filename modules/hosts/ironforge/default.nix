{ self, inputs, ... }:

{
  flake.nixosConfigurations.ironforge =
    let
      secrets = fromTOML (builtins.readFile ../../../secrets/secrets.toml);
    in
    inputs.nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      specialArgs = { inherit secrets; };
      modules = with self.nixosModules; [
        ironforge
      ];
    };

  flake.nixosModules.ironforge = { secrets, ... }: {
    imports = with self.nixosModules; [
      raspberry-pi-4
      tailscale-server
      adguardhome-new-zealand
    ];

    sops.defaultSopsFile = ./ironforge.sops.yaml;

    deploy.tags = [
      "new-zealand"
    ];

    deploy.ipv4-address = secrets.hosts.ironforge.tailscale-address;

    services.getty.autologinUser = "daluca";

    services.tailscale.extraUpFlags = [
      "--advertise-routes=192.168.10.0/24"
      "--hostname=new-zealand"
    ];

    networking.localCommands = /* bash */ ''
      ip rule add to 192.168.10.0/24 priority 2500 lookup main || true
    '';

    networking.hostName = "ironforge";

    system.stateVersion = "26.05";
  };

  flake.nixosModules.ironforge-sshKnownHosts = { config, secrets, ... }: {
    programs.ssh.knownHosts = rec {
      ironforge = {
        extraHostNames = [
          "ironforge.${config.networking.domain}"
          "192.168.10.10"
          secrets.hosts.ironforge.tailscale-address
        ];
        publicKeyFile = ./keys/ssh_host_ed25519_key.pub;
      };
      "ironforge/rsa" = {
        hostNames = [ "ironforge" ] ++ ironforge.extraHostNames;
        publicKeyFile = ./keys/ssh_host_rsa_key.pub;
      };
    };
  };
}
