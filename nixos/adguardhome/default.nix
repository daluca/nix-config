{ config, secrets, ... }:

{
  imports = [
    ../unbound
  ];

  services.adguardhome = {
    enable = true;
    mutableSettings = false;
    openFirewall = true;
    settings = {
      users = [{
        name = config.home-manager.users.daluca.home.username;
        password = secrets.adguardhome.password;
      }];
      dns = {
        upstream_dns = [
          "127.0.0.1:5353"
        ];
        bootstrap_dns = [
          "9.9.9.9"
          "149.112.112.112"
        ];
      };
      filters = [{
        enabled = true;
        url = "https://big.oisd.nl/";
        name = "oisd big";
        id = 1;
      }];
    };
  };
}
