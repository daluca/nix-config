{ config, lib, ... }:

{
  virtualisation.docker = {
    enable = true;
    autoPrune.enable = true;
    storageDriver = lib.mkIf ( config.fileSystems."/".fsType == "btrfs" ) "btrfs";
    daemon.settings = {
      userland-proxy = false;
      experimental = true;
      ipv6 = true;
      fixed-cidr-v6 = "fd00::/80";
    };
  };

  environment.persistence.system.directories = lib.mkIf config.environment.persistence.system.enable [
    { directory = "/var/lib/docker"; mode = "0710"; }
  ];

  users.users.daluca.extraGroups = [ "docker" ];
}
