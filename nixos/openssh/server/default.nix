{
  services.openssh = {
    enable = true;
    startWhenNeeded = true;
    ports = [ 22 ];
    settings = {
      PermitRootLogin = "prohibit-password";
      PasswordAuthentication = false;
      X11Forwarding = false;
    };
  };
}
