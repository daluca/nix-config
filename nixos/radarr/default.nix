{ secrets, ... }:

{
  services.radarr = {
    enable = true;
    openFirewall = true;
    group = "starr";
  };

  services.nginx.virtualHosts = {
    "radarr.${secrets.parents.domain}" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:7878";
      };
    };
  };
}
