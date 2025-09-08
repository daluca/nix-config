{ config, lib, ... }:
let
  ntfy-sh = config.services.ntfy-sh;
in {
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

  services.nginx.virtualHosts =
  let
    url = lib.last (builtins.match "^https?://(.*)$" ntfy-sh.settings.base-url);
  in {
    ${url} = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://${ntfy-sh.settings.listen-http}";
        proxyWebsockets = true;
      };
    };
  };

  environment.persistence.system.directories = [
    { directory = "/var/lib/ntfy-sh"; mode = "0775"; }
  ];
}
