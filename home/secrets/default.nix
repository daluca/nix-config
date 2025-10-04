{ config, lib, inputs, ... }:
let
  inherit (config.home) username;
in {
  imports = with inputs; [
    sops-nix.homeManagerModules.sops
  ];

  sops = {
    defaultSopsFile = lib.custom.relativeToUsers "${username}/${username}.sops.yaml";
    age.keyFile = "${config.xdg.configHome}/sops/age/keys.txt";
    age.sshKeyPaths = [
      "${config.home.homeDirectory}/.ssh/id_ed25519"
    ];
  };

  home.persistence.home.directories = [
    ".config/sops/age"
  ];
}
