{
  flake.nixosModules.local-content-share = {
    services.local-content-share = {
      enable = true;
      listenAddress = "127.0.0.1";
    };
  };
}
