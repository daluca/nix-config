{ config, pkgs, inputs, ... }:

{
  imports = with inputs; [
    rustfs.nixosModules.rustfs
  ];

  services.rustfs = {
    enable = true;
    package = pkgs.rustfs;
    address = "127.0.0.1:9000";
    consoleAddress = "127.0.0.1:9001";
    accessKeyFile = config.sops.secrets."rustfs/access-key".path;
    secretKeyFile = config.sops.secrets."rustfs/secret-key".path;
  };

  sops.secrets."rustfs/access-key" = with config.services; {
    restartUnits = [ "rustfs.service" ];
    owner = rustfs.user;
    group = rustfs.group;
    mode = "0400";
  };

  sops.secrets."rustfs/secret-key" = with config.services; {
    restartUnits = [ "rustfs.service" ];
    owner = rustfs.user;
    group = rustfs.group;
    mode = "0400";
  };

  networking.firewall.allowedTCPPorts = [
    9000
    9001
  ];

  environment.persistence.system.directories = with config.services; [
    {
      directory = "/var/lib/rustfs";
      user = rustfs.user;
      group = rustfs.group;
      mode = "0750";
    }
  ];
}
