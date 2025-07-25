{ config, lib, inputs, ... }:

{
  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];

  sops = {
    defaultSopsFile = lib.custom.relativeToRoot "secrets/secrets.sops.yaml";
    age.keyFile = "${config.xdg.configHome}/sops/age/keys.txt";
    age.sshKeyPaths = [
      "${config.home.homeDirectory}/.ssh/id_ed25519"
    ];
  };

  home.persistence.home.directories = [
    ".config/sops/age"
  ];
}
