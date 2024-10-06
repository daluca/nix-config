{
  services.unbound = {
    enable = true;
    settings = {
      server.interface = [ "127.0.0.1@5353" ];
    };
  };
}
