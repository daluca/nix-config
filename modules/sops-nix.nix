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

  flake.homeManagerModules.sops-nix = { config, lib, ... }: {
    imports = with inputs; [
      sops-nix.homeManagerModules.sops
    ];

    sops = {
      defaultSopsFile = lib.path.append ../users "${config.home.username}/${config.home.username}.sops.yaml";
      age.keyFile = "${config.xdg.configHome}/sops/age/keys.txt";
      # age.sshKeyPaths = [
      #   "${config.home.homeDirectory}/.ssh/id_ed25519"
      # ];
    };

    home.persistence.home.files = [
      ".config/sops/age/keys.txt"
    ];
  };
}
