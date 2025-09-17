{ config, lib, inputs, ... }@args:
let
  secrets = args.secrets // builtins.fromTOML (builtins.readFile ./secrets.toml);
in {
  imports = [
    inputs.disko.nixosModules.disko

    ./disko.nix
  ] ++ map (m: lib.custom.relativeToRoot m) [
    "images/hetzner/cloud/x86"
  ] ++ map (m: lib.custom.relativeToHosts m) [
    "."
  ] ++ map (m: lib.custom.relativeToUsers m) [
    "remotebuild"
  ] ++ map (m: lib.custom.relativeToNixosModules m) [
    "impermanence"
    "nginx"
    "tailscale/server"
  ];


  services.nginx.virtualHosts = {
      forceSSL = true;
      enableACME = true;
    };
  };

  sops.secrets."tailscale/preauthkey".sopsFile = ./alfa.sops.yaml;

  networking.hostName = "alfa";

  nix.settings.secret-key-files = config.sops.secrets."cache-priv-key.pem".path;

  sops.secrets."cache-priv-key.pem".sopsFile = ./alfa.sops.yaml;

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

  sops.secrets."ssh_host_ed25519_key".sopsFile = ./alfa.sops.yaml;

  sops.secrets."ssh_host_rsa_key".sopsFile = ./alfa.sops.yaml;

  system.stateVersion = "25.05";
}
