{ secrets, ... }:

rec {
  services.qbittorrent = {
    enable = true;
    port = 8081;
    openFirewall = true;
  };

  services.nginx.virtualHosts = {
    "qbittorrent.${secrets.parents.domain}" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:${builtins.toString services.qbittorrent.port}";
      };
    };
  };
}
