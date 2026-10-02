{ self, inputs, ... }:

{
  flake.nixosConfigurations.darnassus =
    let
      secrets = fromTOML (builtins.readFile ../../../secrets/secrets.toml);
    in
    inputs.nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      specialArgs = { inherit secrets; };
      modules = with self.nixosModules; [
        darnassus
      ];
    };

  flake.nixosModules.darnassus = {
    imports = with self.nixosModules; [
      raspberry-pi-4
      raspberry-pi-4-gpio-fan
      tailscale-server
    ];

    sops.defaultSopsFile = ./darnassus.sops.yaml;

    deploy.tags = [
      "united-kingdom"
    ];

    services.getty.autologinUser = "daluca";

    networking.hostName = "darnassus";

    networking.localCommands = /* bash */ ''
      ip rule add to 192.168.1.0/24 priority 2500 lookup main || true
    '';

    services.tailscale.extraUpFlags = [
      "--advertise-routes=192.168.1.0/24"
      "--hostname=united-kingdom"
    ];

    system.stateVersion = "26.05";
  };

  flake.nixosModules.darnassus-sshKnownHosts = { config, ... }: {
    programs.ssh.knownHosts = rec {
      darnassus = {
        extraHostNames = [
          "darnassus.${config.networking.domain}"
          "192.168.1.212"
          "100.64.0.14"
        ];
        publicKeyFile = ./keys/ssh_host_ed25519_key.pub;
      };
      "darnassus/rsa" = {
        hostNames = [ "darnassus" ] ++ darnassus.extraHostNames;
        publicKeyFile = ./keys/ssh_host_rsa_key.pub;
      };
    };
  };
}
