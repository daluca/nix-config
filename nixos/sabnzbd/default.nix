{ secrets, ... }:

{
  services.sabnzbd = {
    enable = true;
    openFirewall = true;
    group = "starr";
  };

  services.nginx.virtualHosts = {
    "sabnzbd.${secrets.parents.domain}" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:8080";
      };
    };
  };
}
