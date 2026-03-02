{ config, lib, inputs, ... }:

{
  imports = with inputs; [
    sops-nix.nixosModules.sops
  ];

  sops = let
    inherit (config.networking) hostName;
  in {
    useSystemdActivation = true;
    defaultSopsFile = lib.custom.relativeToHosts "${hostName}/${hostName}.sops.yaml";
    age.keyFile = "/var/lib/sops-nix/keys.txt";
  };

  environment.persistence.system.files = [
    "/var/lib/sops-nix/keys.txt"
  ];
}
