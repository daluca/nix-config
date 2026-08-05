{ inputs, ... }:

{
  flake.nixosModules.sops-nix = { config, lib, ... }: {
    imports = with inputs; [
      sops-nix.nixosModules.sops
    ];

    sops = {
      useSystemdActivation = true;
      defaultSopsFile = lib.path.append ../hosts "${config.networking.hostName}/${config.networking.hostName}.sops.yaml";
      age.keyFile = "/var/lib/sops-nix/keys.txt";
    };

    environment.persistence.system.files = [
      "/var/lib/sops-nix/keys.txt"
    ];
  };
}
