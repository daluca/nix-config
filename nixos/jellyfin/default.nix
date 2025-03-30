{ secrets, ... }:

{
  services.jellyfin = {
    enable = true;
    openFirewall = true;
  };

  services.nginx.virtualHosts = {
    "jellyfin.${secrets.parents.domain}" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:8096";
      };
    };
  };
}
