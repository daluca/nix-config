{ config, ... }:

{
  services.openssh = {
    enable = true;
    startWhenNeeded = true;
    ports = [ 22 ];
    settings = {
      AllowUsers = [ "${config.home-manager.users.daluca.home.username}" ];
      PermitRootLogin = "no";
      PasswordAuthentication = false;
      X11Forwarding = false;
    };
  };
}
