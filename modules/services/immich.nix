{ inputs, ... }:

{
  flake.nixosModules.immich = { config, pkgs, secrets, ... }: {
    disabledModules = [
      "services/web-apps/immich.nix"
    ];

    imports = with inputs; [
      (nixpkgs-unstable + "/nixos/modules/services/web-apps/immich.nix")
    ];

    services.immich = {
      enable = true;
      package = pkgs.unstable.immich;
      host = "127.0.0.1";
      settings = {
        server.externalDomain = "https://immich.${secrets.domain.general}";
      };
    };

    services.nginx.virtualHosts."immich.${secrets.domain.general}" = {
      locations."/" = with config.services.immich; {
        proxyPass = "http://${host}:${toString port}/";
        proxyWebsockets = true;
      };
      extraConfig = /* nginx */ ''
        client_max_body_size 50000M;
        proxy_request_buffering off;
        client_body_buffer_size 1024k;
      '';
    };
  };
}
