{
  flake.nixosModules.homebox = {
    services.homebox = {
      enable = true;
      settings = {
        HBOX_OPTIONS_TRUST_PROXY = toString true;
      };
    };
  };
}
