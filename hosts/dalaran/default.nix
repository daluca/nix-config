{ config, lib, secrets, inputs, ... }:

{
  imports = with inputs; [
    disko.nixosModules.disko
  ] ++ [
    ./..
    ./disko.nix
    ./adguardhome.nix
  ] ++ map (m: lib.custom.relativeToRoot m) [
    "images/raspberry-pi/5"
  ] ++ map (m: lib.custom.relativeToUsers m) [
    "remotebuild"
    "starr"
  ] ++ map (m: lib.custom.relativeToNixosModules m) [
    "openssh/server"
    "nginx"
    "adguardhome"
    "paperless"
    "redlib"
    "firefly-iii"
    "navidrome"
    "jellyfin"
    "jellyseerr"
    "sonarr"
    "radarr"
    "prowlarr"
    "sabnzbd"
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
    FIREFLY_III_CLIENT_ID = 2;
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
