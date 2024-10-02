{ config, pkgs, secrets, ... }:

{
  services.adguardhome = {
    enable = true;
    package = pkgs.unstable.adguardhome;
    mutableSettings = false;
    openFirewall = true;
    settings = {
      users = [{
        name = config.home-manager.users.daluca.home.username;
        password = secrets.adguardhome.password;
      }];
    };
  };
}
