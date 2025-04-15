{ secrets, ... }:

{
  services.sonarr = {
    enable = true;
    openFirewall = true;
    group = "starr";
  };

  services.nginx.virtualHosts = {
    "sonarr.${secrets.parents.domain}" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:8989";
      };
    };
  };
}
