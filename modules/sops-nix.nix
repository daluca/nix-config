{ inputs, ... }:

{
  flake.nixosModules.sops-nix = {
    imports = with inputs; [
      sops-nix.nixosModules.sops
    ];

    sops = {
      useSystemdActivation = true;
      # TODO: Try re-enable option
      # defaultSopsFile = lib.path.append ../hosts "${config.networking.hostName}/${config.networking.hostName}.sops.yaml";
      age.keyFile = "/var/lib/sops-nix/keys.txt";
      age.sshKeyPaths = [ ];
      gnupg.sshKeyPaths = [ ];
    };

    environment.persistence.system.files = [
      "/var/lib/sops-nix/keys.txt"
    ];
  };

  flake.homeManagerModules.sops-nix = { config, ... }: {
    imports = with inputs; [
      sops-nix.homeManagerModules.sops
    ];

    sops = {
      defaultSopsFile = ./users/daluca/daluca.sops.yaml;
      age.keyFile = "${config.xdg.configHome}/sops/age/keys.txt";
      # TODO: Try and re-enable option
      # age.sshKeyPaths = [
      #   "${config.home.homeDirectory}/.ssh/id_ed25519"
      # ];
    };

    home.persistence.home.files = [
      ".config/sops/age/keys.txt"
    ];
  };
}
