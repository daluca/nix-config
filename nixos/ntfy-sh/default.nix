{ lib, ... }:

{
  services.ntfy-sh = {
    enable = true;
    settings = {
      listen-http = "127.0.0.1:8080";
      behind-proxy = true;
      enable-login = true;
      auth-default-access = "deny-all";
    };
  };

  systemd.services.ntfy-sh.serviceConfig = {
    DynamicUser = lib.mkForce false;
    PrivateTmp = lib.mkForce false;
    UMask = "0002";
  };

  users.users.daluca.extraGroups = [ "ntfy-sh" ];

  environment.persistence.system.directories = [
    { directory = "/var/lib/ntfy-sh"; mode = "0775"; }
  ];
}
