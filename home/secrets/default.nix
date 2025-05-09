{ config, lib, ... }:

{
  sops = {
    defaultSopsFile = lib.custom.relativeToRoot "secrets/secrets.sops.yaml";
    age.keyFile = "${config.xdg.configHome}/sops/age/nix-config.txt";
  };

  home.persistence.home.directories = [
    ".config/sops/age"
  ];
}
