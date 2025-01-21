{ config, ... }:

{
  services.openssh = {
    enable = true;
    startWhenNeeded = true;
    ports = [ 22 ];
    settings = {
      AllowUsers = [ "root" config.home-manager.users.daluca.home.username ];
      PasswordAuthentication = false;
      X11Forwarding = false;
    };
  };
}
