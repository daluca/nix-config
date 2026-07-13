{
  config,
  lib,
  secrets,
  inputs,
  outputs,
  ...
}:

{
  imports =
    with inputs;
    with outputs.nixosModules;
    [
      ./..
      ./disko.nix
      ./adguardhome.nix

      raspberry-pi-5

      disko.nixosModules.disko
    ]
    ++ map (m: lib.custom.relativeToUsers m) [
      "remotebuild"
    ]
    ++ map (m: lib.custom.relativeToNixosModules m) [
      "openssh/server"
      "nginx"
      "adguardhome"
      "paperless"
      "redlib"
      "firefly-iii"
      "navidrome"
      "local-content-share"
      "gatus"
    ];

  security.acme.certs.${secrets.domain.general}.domain = "*.${secrets.domain.general}";

  services.nginx.virtualHosts = import ./routes.nix { inherit config secrets; };

  services.paperless.settings = {
    PAPERLESS_URL = "https://paperless.${secrets.domain.general}";
  };

  services.firefly-iii.virtualHost = "firefly.${secrets.domain.general}";

  services.firefly-iii-data-importer.virtualHost = "firefly-importer.${secrets.domain.general}";

  services.firefly-iii-data-importer.settings = {
    VANITY_URL = "https://firefly.${secrets.domain.general}";
    FIREFLY_III_URL = "https://firefly.${secrets.domain.general}";
    FIREFLY_III_CLIENT_ID = "019f5ca9-1f9a-71a5-a0a1-9733ffb75a50";
  };

  services.redlib.settings = {
    REDLIB_FULL_URL = "redlib.${secrets.domain.general}";
  };

  networking.hostName = "dalaran";

  hardware.raspberry-pi.config = {
    all.base-dt-params = {
      pciex1_gen = {
        enable = true;
        value = 3;
      };
    };
  };

  system.stateVersion = "25.11";
}
