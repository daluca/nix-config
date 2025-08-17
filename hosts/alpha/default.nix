{ config, lib, inputs, ... }@args:
let
  secrets = args.secrets // builtins.fromTOML (builtins.readFile ./secrets.toml);
in {
  imports = [
    inputs.disko.nixosModules.disko

    ./disko.nix
    ./hardware-configuration.nix
  ] ++ map (m: lib.custom.relativeToRoot m) [
    "images/hetzner"
  ] ++ map (m: lib.custom.relativeToHosts m) [
    "."
  ] ++ map (m: lib.custom.relativeToNixosModules m) [
    "adguardhome"
    "impermanence"
    "nginx"
  ];

  services.adguardhome = {
    port = lib.mkForce 3000;
    settings = {
      users = lib.mkForce [
        {
          name = config.home-manager.users.daluca.home.username;
          password = secrets.adguardhome.daluca.password;
        }
      ];
      dns.bind_hosts = [
        secrets.hosts.alpha.ipv4-address
      ];
    };
  };

  services.nginx.virtualHosts = {
    "adguardhome.${secrets.cloud.domain}" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:${builtins.toString config.services.adguardhome.port}";
      };
    };
  };

  networking.hostName = "alpha";

  boot = {
    kernelParams = [ "ip=dhcp" ];
    initrd = {
      availableKernelModules = [ "virtio-pci" ];
      network = {
        enable = true;
        ssh = {
          enable = true;
          port = 22;
          authorizedKeyFiles = [
            (lib.custom.relativeToUsers "daluca/keys/id_ed25519.pub")
          ];
          hostKeys = [
            "/persistent/system/etc/ssh/ssh_host_ed25519_key"
            "/persistent/system/etc/ssh/ssh_host_rsa_key"
          ];
          shell = "/bin/cryptsetup-askpass";
        };
      };
    };
  };

  sops.secrets."ssh_host_ed25519_key".sopsFile = ./alpha.sops.yaml;

  sops.secrets."ssh_host_rsa_key".sopsFile = ./alpha.sops.yaml;

  system.stateVersion = "25.05";
}
