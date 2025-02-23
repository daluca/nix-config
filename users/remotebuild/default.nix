{ config, ... }:

{
  users.users.remotebuild = {
    isNormalUser = true;
    home = "/var/empty";
    createHome = false;
    group = config.users.groups.remotebuild.name;
    openssh.authorizedKeys.keyFiles = [
      ../../hosts/artemis/keys/ssh_host_ed25519_key.pub
    ];
  };

  users.groups.remotebuild = { };

  nix.settings = {
    trusted-users = [
      config.users.users.remotebuild.name
    ];
    min-free = 10 * 1024 * 1024; # 10MiB
    max-free = 200 * 1024 * 1024; # 200MiB
  };

  systemd.services.nix-daemon.serviceConfig = {
    MemoryAccounting = true;
    MemoryMax = "90%";
    OOMScoreAdjust = 500;
  };

  services.openssh.settings.AllowUsers = [
    config.users.users.remotebuild.name
  ];
}
