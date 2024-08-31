{ config, lib, ... }:

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

  environment.persistence.system.directories = lib.mkIf config.environment.persistence.system.enable [
    "/etc/ssh"
  ];
}
